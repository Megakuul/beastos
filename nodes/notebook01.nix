# Office Notebook
{ config, lib, pkgs, pkgs-unstable, home-manager, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../modules/notebook.nix
    ];

  networking.hostName = "beast-notebook-01";
  networking.useDHCP = false;
  networking.bridges.br0.interfaces = [ "eth0" ];
  networking.interfaces.br0.useDHCP = true;

  fileSystems."/" = {
    neededForBoot = true;
    device = "none";
    fsType = "tmpfs";
    options = [ "defaults" "size=50%" "mode=755" ];
  };

  fileSystems."/nix" = {
    device = "/dev/mapper/cryptroot"; # requires the root device to be mapped on cryptroot
    fsType = "ext4";
    neededForBoot = true;
  };

  environment.persistence."/nix/persist" = {
    directories = [
      "/etc/nixos"
      "/home"
      "/root"
      "/var"
      "/etc"
    ];
  };  
}
