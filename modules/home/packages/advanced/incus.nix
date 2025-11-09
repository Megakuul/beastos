{pkgs, ...}: let
  # here some ai slop bashscripts that effectively launch a daemon
  # which starts the incus webui once and stores the token into a file.
  # I know I will burn in hell for this dogwater solution, but the incus mTLS browser solution is just so cumbersome...
  incusClient = pkgs.writeShellScript "incus-client" ''
    #!/usr/bin/env bash
    set -euo pipefail

    : "''${XDG_RUNTIME_DIR:="/run/user/$(id -u)"}"
    URL_FILE="''${XDG_RUNTIME_DIR}/incus-webui.url"

    if [[ ! -s "$URL_FILE" ]]; then
      if command -v zenity >/dev/null 2>&1; then
        ${pkgs.zenity}/bin/zenity --warning --no-wrap --text="Incus Web UI URL not available.\n\nStart your user service:\n  systemctl --user start incus-webui.service"
      else
        printf 'Incus Web UI URL not available.\nStart with: systemctl --user start incus-webui.service\n' >&2
      fi
      exit 1
    fi

    url="$(head -n1 "$URL_FILE" | xargs)"
    exec ${pkgs.brave}/bin/brave --app="$url"
  '';
  incusWebuiService = pkgs.writeShellScript "incus-webui-service" ''
    #!/usr/bin/env bash
    set -euo pipefail

    : "''${XDG_RUNTIME_DIR:="/run/user/$(id -u)"}"
    URL_FILE="''${XDG_RUNTIME_DIR}/incus-webui.url"

    umask 077
    coproc WEBUI { ${pkgs.coreutils}/bin/stdbuf -oL incus webui; }

    while IFS= read -r line <&"''${WEBUI[0]}"; do
      case "$line" in
        *http://*|*https://*)
          url="''${line#*:}"
          printf '%s\n' "$(${pkgs.coreutils}/bin/printf '%s' "''${url}" | ${pkgs.coreutils}/bin/xargs)" >"''${URL_FILE}"
          break
          ;;
      esac
    done

    wait "''${WEBUI_PID}"
  '';
in {
  home.packages = [pkgs.brave pkgs.zenity];
  systemd.user.services.incus-webui = {
    Unit = {
      Description = "Incus Web UI headless runner publishing URL";
    };
    Service = {
      Type = "simple";
      ExecStart = "${incusWebuiService}";
      Restart = "on-failure";
      RestartSec = 2;
    };
    Install = {
      WantedBy = ["default.target"];
    };
  };
  xdg.desktopEntries."incus" = {
    name = "Incus UI";
    exec = "${incusClient}";
    icon = "virtualbox";
    categories = ["Emulator" "System" "Utility"];
    terminal = false;
  };
}
