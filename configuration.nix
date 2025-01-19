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

  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

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
    home.file.".config/waybar/" = {
      source = ./config/waybar;
      recursive = true;
    };
    home.file.".config/sys64/menu/" = {
      source = ./config/sysmenu;
      recursive = true;
    };
    home.file.".config/rofi/config.rasi".source = ./config/rofi/config.rasi;
    home.file.".config/starship.toml".source = ./config/starship/config.toml;

    home.shellAliases = {
      ll = "ls -al";
      s = "sudo";
      sc = "grim -g \"$(slurp)\" - | wl-copy";
      sysmacs = "sudo emacs -nw --no-init-file --load ~/.emacs /etc/nixos/configuration.nix";
    };

    programs.bash.enable = true; # required to make shellAliases work.
    programs.starship.enable = true; # required to fix bash, visually.

    gtk = {
      enable = true;
      theme = {
        name = "Yaru-dark";
        package = pkgs.yaru-theme;
      };
    
      iconTheme = {
        name = "WhiteSur-dark";
	      package = pkgs.whitesur-icon-theme;
      };
    };

    qt = {
      enable = true;
      platformTheme.name = "qt5ct";
    };
  };

  nixpkgs.config.allowUnfree = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  fonts.packages = with pkgs; [
    iosevka
    nerdfonts
    font-awesome
    inter
  ];

  environment.systemPackages = with pkgs; [
    emacs
    git
    brave
    discord
    steam
    wget
    curl
    vscode
    nautilus
    kitty
    gh
    fastfetch
    starship
    cmake
    gnumake
    gtkmm3
    pkg-config
    gcc14
    clang-tools
    gtkmm3
    gtkmm4
    jq

    pavucontrol
    mako
    libnotify
    hyprpaper
    slurp
    grim
    wl-clipboard
    sysmenu
    waybar
    playerctl
    pamixer
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

