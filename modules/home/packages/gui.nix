{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ## Multimedia
    hoppscotch
    joplin-desktop
    calibre
    reaper
    spotify
    audacity
    godot
    krita
    obs-studio
    pavucontrol
    pitivi # video editing
    soundwireserver
    vlc
    wl-screenrec
    rustdesk-flutter

    ## Office
    libreoffice
    gnome-calculator

    ## Utility
    dconf-editor
    gnome-disk-utility
    mission-center # GUI resources monitor
    zenity
  ];
}
