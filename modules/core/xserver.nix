{
  pkgs,
  username,
  ...
}: {
  services = {
    xserver = {
      enable = true;
      xkb.layout = "ch";
      excludePackages = [pkgs.xterm];
    };

    displayManager.autoLogin = {
      enable = true;
      user = "${username}";
    };
    libinput = {
      enable = true;
    };
  };
}
