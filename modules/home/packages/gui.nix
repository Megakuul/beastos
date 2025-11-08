{pkgs, ...}: {
  home.packages = with pkgs; [
    # multimedia
    spotify
    gimp3-with-plugins
    penpot-desktop
    obs-studio
    pavucontrol
    vlc
    kdePackages.kdenlive
    tenacity

    # office
    libreoffice
    gnome-calculator

    # password
    bitwarden-desktop
    _1password-gui

    # utility
    gnome-disk-utility
    mission-center # GUI resources monitor

    # analysis
    ghidra
    wireshark
    kdePackages.kleopatra

    # virtualisation
    gnome-boxes
    osinfo-db
    osinfo-db-tools
    virt-manager
    tigervnc

    # remotemanagement tooling
    remmina
  ];
}
