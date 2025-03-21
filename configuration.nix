{ config, lib, pkgs, pkgs-unstable, home-manager, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
    efiInstallAsRemovable = true;
    splashImage = "/etc/nixos/boot-splash-image.jpg";
  };
  
  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver.xkb.layout = "ch";
  console.useXkbConfig = true;

  networking.networkmanager.enable = true;

  nixpkgs.config.allowUnfree = true;

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = true;

  programs.nm-applet.enable = true;
  programs.nm-applet.indicator = true;

  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
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
    gtkmm3
    pkg-config
    gcc14
    clang-tools
    gtkmm4
    jq
    remmina
    _1password-gui
    mission-center
    python39
    asciidoctor

    emacsPackages.vterm
    libvterm # required for vterm in emacs
    libtool # required for vterm compilation in emacs

    pavucontrol
    networkmanagerapplet
    swaynotificationcenter
    libnotify
    hyprpaper
    slurp
    grim
    wl-clipboard
    rofi-wayland
    waybar
    playerctl
    pamixer
    pkgs-unstable.hyprlock
  ];

  programs.hyprland.enable = true;

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  system.stateVersion = "24.11"; # If you change this, I will find you...
}

