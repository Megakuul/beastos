# Home Desktop
{ config, lib, pkgs, pkgs-unstable, home-manager, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../configuration.nix
    ];

  networking.hostName = "beast";
  # networking.useDHCP = false;
  # networking.bridges.br0.interfaces = [ "eth0" ];
  # networking.interfaces.br0.useDHCP = true;

  # services.etcd = {
  #   enable = true;
  #
  #   listenClientUrls = [ "unix:///var/run/cthul/etcd/etcd.sock" ];
  #   advertiseClientUrls = [ "http://0.0.0.0:2379" ];
  #   initialCluster = [ "node1=http://0.0.0.0:2380" ];
  #   initialAdvertisePeerUrls = [ "http://0.0.0.0:2380" ];
  #   listenPeerUrls = [ "http://0.0.0.0:2380" ];
  #   name = "node1";
  # };

  services.gvfs.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  programs.bash.shellAliases = {
    snleash = "sudo nixos-rebuild switch --flake path:/etc/nixos#desktop-01";
  };
}
