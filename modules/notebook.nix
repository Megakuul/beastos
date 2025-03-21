{ config, lib, pkgs, ... }:
{
  services.libinput.enable = true;
  services.printing.enable = true;
}
