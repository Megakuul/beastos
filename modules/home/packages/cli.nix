{pkgs, ...}: {
  home.packages = with pkgs; [
    quickemu

    tldr
    dig
    file
    killall
    jq
    ffmpeg
    unzip
    curl
    wget
    binsider # elf analyzer tui
    man-pages # extra man pages
    pamixer # pulseaudio command line mixer
    playerctl # controller for media players
    yt-dlp-light # download youtube videos

    winetricks
    wineWowPackages.wayland
  ];
}
