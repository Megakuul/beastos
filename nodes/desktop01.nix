# Home Desktop
{ config, lib, pkgs, pkgs-unstable, home-manager, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  networking.hostName = "beast";
  networking.useDHCP = false;
  networking.bridges.br0.interfaces = [ "eth0" ];
  networking.interfaces.br0.useDHCP = true;
}
