{ config, lib, pkgs, ... }:
{
  networking.wireless.enable = true;
  networking.wireless.userControlled.enable = true;
  services.libinput.enable = true;
  services.printing.enable = true;
}
