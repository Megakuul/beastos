# Home Lenovo Desktop
{ config, lib, pkgs, pkgs-unstable, home-manager, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../configuration.nix
    ];

  networking.hostName = "beast";
  programs.bash.shellAliases = {
    snleash = "sudo nixos-rebuild switch --flake path:/etc/nixos#desktop-03";
  };
}
