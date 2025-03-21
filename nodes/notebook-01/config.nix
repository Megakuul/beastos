# Office Notebook
{ config, lib, pkgs, pkgs-unstable, home-manager, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../configuration.nix
      ../../modules/notebook.nix
      ../../users/linus.nix
    ];

  networking.hostName = "beast-notebook-01";

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

  home-manager.users.linus.home.shellAliases.unleash = "sudo nixos-rebuild switch --flake path:/etc/nixos#notebook-01";
  home-manager.users.linus.home.file.".config/hypr/monitors.conf".source = ./monitors.conf;
}
