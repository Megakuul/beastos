{ ... }:
{
  services.kiwi-shell = {
    enable = true;
    settings = {
      primary_color = "rgb(226, 221, 235)";
      theme = "glass";
      bar_margin = 5;
      dock_margin = 5;
      dock_home = true;
      dock_trash = true;
      dock_apps = [
        "codium.desktop"
        "brave-browser.desktop"
        "org.wireshark.Wireshark.desktop"
        "signal.desktop"
        "nwg-displays.desktop"
        "com.rafaelmardojai.Blanket.desktop"
        "draw.io.desktop"
        "figma-linux.desktop"
      ];
    };
  };
}
