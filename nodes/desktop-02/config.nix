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
  networking.useDHCP = false;
  networking.bridges.br0.interfaces = [ "enp3s0" ];
  networking.interfaces.br0.useDHCP = true;

  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  home-manager.users.linus.home.shellAliases.unleash = "sudo nixos-rebuild switch --flake path:/etc/nixos#desktop-02";
  home-manager.users.linus.home.file.".config/hypr/monitors.conf".source = ./monitors.conf;
}
