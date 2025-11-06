{pkgs, ...}: {
  security.rtkit.enable = true;
  security.sudo.enable = true;
  security.pam.services.hyprlock = {};

  security.apparmor = {
    enable = true;
    packages = [pkgs.apparmor-profiles];
  };
}
