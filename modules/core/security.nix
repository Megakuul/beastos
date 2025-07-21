{ ... }:
{
  security.rtkit.enable = true;
  security.sudo.enable = false;
  security.sudo-rs.enable = true;
  security.pam.services.swaylock = { };
  security.pam.services.hyprlock = { };
}
