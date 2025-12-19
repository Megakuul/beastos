{
  config,
  pkgs,
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
      user = "${config.beast.profile.username}";
    };
    libinput = {
      enable = true;
    };
  };
}
