{ lib, ... }:
with lib;
let
  defaultApps = {
    browser = [ "brave.desktop" ];
    text = [ "codium.desktop" ];
    image = [ "ksnip.desktop" ];
    video = [ "vlc.desktop" ];
    figma = [ "figma-linux.desktop" ];
    audio = [ "vlc.desktop" ];
    directory = [ "nautilus.desktop" ];
    office = [ "libreoffice.desktop" ];
    pdf = [ "evince.desktop" ];
    terminal = [ "ghostty.desktop" ];
    archive = [
      "peazip-extract.desktop"
      "peazip.desktop"
    ];
  };

  mimeMap = {
    text = [
      "application/json"
      "application/toml"
      "application/x-yaml"
      "text/csv"
      "text/json"
      "text/markdown"
      "text/plain"
      "text/toml"
      "text/x-c"
      "text/x-c++"
      "text/x-java"
      "text/x-markdown"
      "text/x-python"
      "text/x-rust"
      "text/x-shellscript"
      "text/yaml"
      "x-scheme-handler/vscodium"
    ];
    image = [
      "image/avif"
      "image/bmp"
      "image/gif"
      "image/heic"
      "image/jpeg"
      "image/jpg"
      "image/png"
      "image/svg+xml"
      "image/tiff"
      "image/vnd.microsoft.icon"
      "image/webp"
    ];
    audio = [
      "audio/aac"
      "audio/flac"
      "audio/mp4"
      "audio/mpeg"
      "audio/ogg"
      "audio/opus"
      "audio/wav"
      "audio/webm"
      "audio/x-matroska"
    ];
    video = [
      "video/mp2t"
      "video/mp4"
      "video/mpeg"
      "video/ogg"
      "video/quicktime"
      "video/webm"
      "video/x-flv"
      "video/x-matroska"
      "video/x-msvideo"
      "x-scheme-handler/vlc"
    ];
    browser = [
      "application/xhtml+xml"
      "text/html"
      "x-scheme-handler/about"
      "x-scheme-handler/chrome"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
      "x-scheme-handler/unknown"
    ];
    office = [
      "application/msword"
      "application/rtf"
      "application/vnd.ms-excel"
      "application/vnd.ms-powerpoint"
      "application/vnd.oasis.opendocument.presentation"
      "application/vnd.oasis.opendocument.spreadsheet"
      "application/vnd.oasis.opendocument.text"
      "application/vnd.openxmlformats-officedocument.presentationml.presentation"
      "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
    ];
    pdf = [
      "application/pdf"
    ];
    directory = [
      "inode/directory"
    ];
    archive = [
      "application/bzip2"
      "application/gzip"
      "application/vnd.rar"
      "application/x-7z-compressed"
      "application/x-bzip"
      "application/x-bzip2"
      "application/x-compressed-tar"
      "application/x-gzip"
      "application/x-rar"
      "application/x-tar"
      "application/x-xz"
      "application/zip"
    ];
    figma = [
      "x-scheme-handler/figma"
    ];
  };

  associations =
    with lists;
    listToAttrs (
      flatten (mapAttrsToList (key: map (type: attrsets.nameValuePair type defaultApps."${key}")) mimeMap)
    );
in
{
  xdg.configFile."mimeapps.list".force = true;
  xdg.mimeApps.enable = true;
  xdg.mimeApps.associations.added = associations;
  xdg.mimeApps.defaultApplications = associations;

  home.sessionVariables = {
    # prevent wine from creating file associations
    WINEDLLOVERRIDES = "winemenubuilder.exe=d";
  };
}
