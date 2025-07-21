{ pkgs, ... }:
{
  home.packages = with pkgs; [
    lens
    audacity
    gimp
    obs-studio
    pavucontrol
    pitivi # video editing
    soundwireserver
    vlc

    libreoffice
    gnome-calculator
    _1password-gui

    dconf-editor
    gnome-disk-utility
    mission-center # GUI resources monitor
    zenity

    ldtk
    tiled
  ];
}
