{ pkgs, ... }:
{
  home.packages = with pkgs; [
    putty
    # multimedia
    gimp3-with-plugins
    penpot-desktop
    obs-studio
    pavucontrol
    vlc
    kdePackages.kdenlive
    tenacity
    losslesscut-bin
    drawio
    figma-linux
    ksnip
    evince
    nautilus
    nautilus-python
    nautilus-open-any-terminal
    sushi
    peazip
    gvfs
    code-nautilus
    zenity
    spotube

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
    osinfo-db
    osinfo-db-tools
    virt-manager
    tigervnc

    # remotemanagement tooling
    remmina
  ];
}
