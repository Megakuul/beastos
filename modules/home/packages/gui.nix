{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ## Multimedia
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
    brave

    ## Office
    libreoffice
    gnome-calculator

    # Passwords
    bitwarden-desktop

    ## Utility
    dconf-editor
    gnome-disk-utility
    mission-center # GUI resources monitor
    zenity


    # remotemanagement tooling
    remmina
    astal.cava
  ];
}
