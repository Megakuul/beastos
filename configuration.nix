{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";    
  };
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "beast";

  # notebook settings
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # services.printing.enable = true;


  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver.xkb.layout = "ch";
  console.useXkbConfig = true;

  # Enable sound.
  hardware.pulseaudio.enable = true;
  # OR
  services.pipewire.enable = false;
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.linus = {
    initialPassword = "letmecook";
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  environment.variables = {
    GTK_THEME = "Adwaita:dark";
    QT_QPA_PLATFORMTHEME = "gtk2";
    EMACSLOADPATH = "/etc/xdg/emacs:";
    HYPRLAND_CONFIG_PATH = "/etc/xdg/hypr/hyprland.conf";
  };

  environment.etc."xdg/emacs/init.el".text = builtins.readFile ./emacs.el;

  environment.etc."xdg/hypr/hyprland.conf".text = builtins.readFile ./hyprland.conf;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    emacs
    git
    brave
    discord
    steam
    dolphin
    wget
    curl
    kitty

    waybar
    mako
    libnotify
    hyprpaper
    wofi
  ];

  programs.hyprland.enable = true;

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "24.11"; # If you change this, I will find you...
}

