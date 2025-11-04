{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ## Multimedia
    spotify
    krita
    obs-studio
    pavucontrol
    soundwireserver
    vlc
    wl-screenrec


    ## Office
    libreoffice
    gnome-calculator

    ## Utility
    dconf-editor
    gnome-disk-utility
    mission-center # GUI resources monitor
    zenity

    ## Level editor
    ldtk
    tiled
  ];
}
