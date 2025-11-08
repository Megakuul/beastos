{pkgs, ...}: {
  home.packages = [pkgs.brave];
  xdg.desktopEntries."incus" = {
    name = "Incus UI";
    exec = "${pkgs.brave}/bin/brave --ignore-certificate-errors --app=https://127.0.0.1:10123";
    icon = "virtualbox";
    categories = ["Emulator" "System" "Utility"];
    terminal = false;
  };
}
