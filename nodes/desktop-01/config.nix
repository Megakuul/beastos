# Home Desktop
{ config, lib, pkgs, pkgs-unstable, home-manager, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../configuration.nix
      ../../users/linus.nix
    ];

  networking.hostName = "beast";
  # networking.useDHCP = false;
  # networking.bridges.br0.interfaces = [ "eth0" ];
  # networking.interfaces.br0.useDHCP = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  home-manager.users.linus.home.shellAliases.unleash = "sudo nixos-rebuild switch --flake path:/etc/nixos#desktop-01";
  home-manager.users.linus.home.file.".config/hypr/monitors.conf".source = ./monitors.conf;
}
