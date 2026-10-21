{pkgs, ...}: {
  home.packages = [
    pkgs.awww
  ];
  services.kiwi-shell = {
    enable = true;
    settings = {
      primary_color = "rgb(226, 221, 235)";
      theme = "clear";
      desktop_icons = false;
      bar_margin = 5;
      dock_margin = 5;
      dock_home = true;
      dock_trash = true;
      dock = "auto-hide";
      shortcuts = {
        "launcher" = "Super";
        "app_switcher" = "Alt+Tab";
        "workspace_switcher" = "Super+minus";
        "notification_center" = "";
      };
      dock_apps = [
        "codium.desktop"
        "brave-browser.desktop"
        "org.wireshark.Wireshark.desktop"
        "signal.desktop"
        "nwg-displays.desktop"
        ".virt-manager-wrapped.desktop"
      ];
      search_engine = "google";
      dock_arpeggio = true;
    };
  };
}
