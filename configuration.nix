{ config, lib, pkgs, home-manager, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
    efiInstallAsRemovable = true;
    splashImage = "/etc/nixos/boot-splash-image.jpg";
  };

  networking.hostName = "beast";
  networking.extraHosts = ''
    192.168.122.10 srvprodpodctpub01.local
  '';

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
    extraGroups = [ "wheel" "libvirtd" ];
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
    home.file.".config/rofi/" = {
      source = ./config/rofi;
      recursive = true;
    };
    home.file.".config/starship.toml".source = ./config/starship/config.toml;

    home.shellAliases = {
      ll = "ls -al";
      s = "sudo";
      sc = "grim -g \"$(slurp)\" - | wl-copy";
      sysmacs = "sudo emacs -nw --no-init-file --load ~/.emacs /etc/nixos/configuration.nix";
      unleash-desktop = "sudo nixos-rebuild switch --flake /etc/nixos#desktop";
      unleash-notebook = "sudo nixos-rebuild switch --flake /etc/nixos#notebook";
      unleash-glitches = "sudo nixos-rebuild switch --flake /etc/nixos#desktop-nvidia";
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

  programs.virt-manager.enable = true;
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      swtpm.enable = true;
      ovmf = {
        enable = true;
        packages = [
          (pkgs.OVMFFull.override {
            secureBoot = true;
            tpmSupport = true;
          })
        ];
      };
    };
  };

  fonts.packages = with pkgs; [
    iosevka
    nerdfonts
    font-awesome
    inter
  ];

  environment.systemPackages = with pkgs; [
    emacs
    go
    gopls
    git
    brave
    webcord
    steam
    wget
    curl
    vscode
    nautilus
    kitty
    gh
    go
    gopls
    fastfetch
    starship
    cmake
    gnumake
    pkg-config
    gcc14
    clang-tools
    gtkmm3
    gtkmm4
    jq
    asciidoctor
    rofi-wayland

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

  system.stateVersion = "24.11"; # If you change this, I will find you...
}

