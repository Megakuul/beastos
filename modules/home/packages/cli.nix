{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # generally useful
    ncdu
    tldr
    dig
    file
    killall
    jq
    ffmpeg
    unzip
    ripunzip
    libarchive
    gzip
    pigz
    xz
    zstd
    lz4
    p7zip
    unrar
    atool
    gnupg
    curl
    wget
    lsof
    psmisc
    man-pages # extra man pages
    tree-sitter
    nmap

    # multimedia
    pamixer # pulseaudio command line mixer
    playerctl # controller for media players
    yt-dlp-light # download youtube videos
    castero # music player

    # analysis
    binsider # elf analyzer tui
    step-cli
    openssl

    # remotemanagement
    teleport_18

    # wine
    winetricks
  ];
}
