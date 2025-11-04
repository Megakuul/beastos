{username, ...}: {
  services = {
    xserver = {
      enable = true;
      xkb.layout = "ch";
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
