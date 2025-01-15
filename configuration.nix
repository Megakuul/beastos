{ config, lib, pkgs, ... }:

{
  imports =
    [
      <home-manager/nixos>
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
  # services.libinput.enable = true;
  # services.printing.enable = true;

  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver.xkb.layout = "ch";
  console.useXkbConfig = true;

  hardware.pulseaudio.enable = true;
  services.pipewire.enable = false;

  users.users.linus = {
    initialPassword = "letmecook";
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  home-manager.users.linus = {
    home.stateVersion = "24.11";
    home.file.".emacs".source = ./emacs.el;
    home.file.".config/hypr/" = {
      source = ./config/hypr;
      recursive = true;
    };
    home.file.".config/rofi/config.rasi".source = ./config/rofi/config.rasi;
    home.file.".config/waybar/style.css".source = ./config/waybar/style.css;
    home.file.".config/starship.toml".source = ./config/starship/config.toml;

    home.shellAliases = {
      ll = "ls -al";
      s = "sudo";
      sysmacs = "sudo emacs -nw --no-init-file --load ~/.emacs /etc/nixos/configuration.nix";
    };

    programs.bash.enable = true; # required to make shellAliases work.
    programs.starship.enable = true; # required to fix bash, visually.

    gtk = {
      enable = true;
      theme = {
        name = "Breeze-Dark";
      	package = pkgs.libsForQt5.breeze-gtk;
      };
    
      iconTheme = {
        name = "Papirus-Dark";
	      package = pkgs.catppuccin-papirus-folders.override {
	        flavor = "mocha";
	        accent = "lavender";
	      };
      };
    
      gtk3 = {
        extraConfig.gtk-application-prefer-dark-theme = true;
      };
    };

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        gtk-theme = "Breeze-Dark";
	      color-scheme = "prefer-dark";
      };
    };

    qt = {
      enable = true;
      platformTheme = "gtk";
      style = {
        name = "gtk2";
      	package = pkgs.libsForQt5.breeze-qt5;
      };
    };
  };

  nixpkgs.config.allowUnfree = true;

  fonts.packages = with pkgs; [
    iosevka
  ];

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
    gh
    fastfetch
    starship

    waybar
    mako
    libnotify
    hyprpaper
    rofi-wayland
    matcha-gtk-theme
    papirus-icon-theme
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

