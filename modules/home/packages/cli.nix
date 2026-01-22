{pkgs, ...}: {
  home.packages = with pkgs; [
    # generally useful
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

    # multimedia
    pamixer # pulseaudio command line mixer
    playerctl # controller for media players
    yt-dlp-light # download youtube videos

    # analysis
    binsider # elf analyzer tui
    step-cli
    openssl

    # remotemanagement
    teleport_18

    # wine
    winetricks
    wineWowPackages.wayland
  ];
}
