{ config, lib, pkgs, ... }:
{
  networking.wireless.enable = true;
  services.libinput.enable = true;
  services.printing.enable = true;
}
