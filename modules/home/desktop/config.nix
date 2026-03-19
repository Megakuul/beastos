{ ... }:
{
  xdg.configFile."k9s/config.yaml".text = ''
    k9s:
      liveViewAutoRefresh: false
      refreshRate: 2
      maxConnRetry: 5
      readOnly: false
      ui:
        enableMouse: false
        headless: false
        logoless: true
        crumbsless: false
        noIcons: false
        reactive: false
        skin: transparent
  '';
  xdg.configFile."k9s/skins/transparent.yaml".text = ''
    k9s:
      body:
        bgColor: default
      prompt:
        bgColor: default
      info:
        sectionColor: default
      dialog:
        bgColor: default
        labelFgColor: default
        fieldFgColor: default
      frame:
        crumbs:
          bgColor: default
        title:
          bgColor: default
          counterColor: default
        menu:
          fgColor: default
      views:
        charts:
          bgColor: default
        table:
          bgColor: default
          header:
            fgColor: default
            bgColor: default
        xray:
          bgColor: default
        logs:
          bgColor: default
          indicator:
            bgColor: default
            toggleOnColor: default
            toggleOffColor: default
        yaml:
          colonColor: default
          valueColor: default
  '';

  # certificate viewer in nautilus
  home.file.".local/share/nautilus/scripts/view_certificate_link.sh" = {
    text = ''
      #!/bin/sh

      for filename in "$@"; do
          VERIFY_OUTPUT=$(osslsigncode verify "$filename" 2>&1)
          
          if [[ "$VERIFY_OUTPUT" == *"Signature verification: ok"* ]]; then
              HEADER="✅ SIGNATURE IS VALID"
          else
              HEADER="❌ INVALID OR UNSIGNED"
          fi

          SIGFILE=$(mktemp)
          osslsigncode extract-signature -in "$filename" -out "$SIGFILE" &> /dev/null
          
          if [ -s "$SIGFILE" ]; then
              CERT_DETAILS=$(openssl pkcs7 -inform der -in "$SIGFILE" -print_certs -text 2>&1)
          else
              CERT_DETAILS="No certificate found to inspect."
          fi

          rm "$SIGFILE"

          (
              echo "=================================================="
              echo "$HEADER"
              echo "File: $filename"
              echo "=================================================="
              echo ""
              echo "--- VERIFICATION OUTPUT ---"
              echo "$VERIFY_OUTPUT"
              echo ""
              echo "=================================================="
              echo "         CERTIFICATE DETAILS (INSPECTION)         "
              echo "=================================================="
              echo "$CERT_DETAILS"
          ) | zenity --text-info \
            --title="Signature Inspector - $filename" \
            --width=800 --height=600 \
            --font="Monospace 10"
      done
    '';
    force = true;
  };
  # ugly hack to fix https://github.com/nix-community/home-manager/issues/3090
  home.activation.makeNautilusScriptsExecutable = {
    after = [ "linkGeneration" ];
    before = [ ];
    data = ''
      export SCRIPT_PATH="~/.local/share/nautilus/scripts"
      cp ~/.local/share/nautilus/scripts/view_certificate_link.sh ~/.local/share/nautilus/scripts/view_certificate.sh
      chmod 500 ~/.local/share/nautilus/scripts/view_certificate.sh
    '';
  };
}
