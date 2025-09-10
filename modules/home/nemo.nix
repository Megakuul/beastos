{ pkgs, ... }:
{
  home.packages = with pkgs; [ nemo peazip ];

  dconf.settings = {
    "org/nemo/preferences" = {
      always-use-browser = true;
      # click-double-parent-folder = true;
      close-device-view-on-device-eject = true;
      date-font-choice = "auto-mono";
      date-format = "iso";
      last-server-connect-method = 3;
      quick-renames-with-pause-in-between = true;
      show-edit-icon-toolbar = false;
      show-full-path-titles = false;
      show-hidden-files = true;
      show-home-icon-toolbar = true;
      show-new-folder-icon-toolbar = true;
      show-open-in-terminal-toolbar = false;
      show-search-icon-toolbar = false;
      show-show-thumbnails-toolbar = false;
      thumbnail-limit = 10485760;
    };
    "org/nemo/preferences/menu-config" = {
      background-menu-open-as-root = false;
      selection-menu-open-as-root = false;
      selection-menu-open-in-terminal = false;
      selection-menu-scripts = false;
    };
    "org/nemo/search" = {
      search-reverse-sort = false;
      search-sort-column = "name";
    };
    "org/nemo/window-state" = {
      maximized = true;
      network-expanded = true;
      side-pane-view = "places";
      sidebar-bookmark-breakpoint = 2;
      sidebar-width = 220;
      start-with-sidebar = true;
    };
  };

  home.file.".local/share/nemo/actions/compress.nemo_action".text=''
    [Nemo Action]
    Active=true
    Name=Compress
    Comment=Compress file with peazip
    Exec=env GDK_BACKEND=x11 QT_QPA_PLATFORM=xcb peazip -add2archive %F
    Selection=notnone
    Extensions=any
  '';

  home.file.".local/share/nemo/actions/extract.nemo_action".text=''
    [Nemo Action]
    Active=true
    Name=Extract here
    Comment=Extract archives with peazip
    Exec=env GDK_BACKEND=x11 QT_QPA_PLATFORM=xcb peazip -ext2here %F
    Selection=s
    Mimetypes=application/bzip2;application/gzip;application/vnd.android.package-archive;application/vnd.ms-cab-compressed;application/vnd.debian.binary-package;application/x-7z-compressed;application/x-7z-compressed-tar;application/x-ace;application/x-alz;application/x-ar;application/x-archive;application/x-arj;application/x-brotli;application/x-bzip-brotli-tar;application/x-bzip;application/x-bzip-compressed-tar;application/x-bzip1;application/x-bzip1-compressed-tar;application/x-cabinet;application/x-cd-image;application/x-compress;application/x-compressed-tar;application/x-cpio;application/x-chrome-extension;application/x-deb;application/x-ear;application/x-ms-dos-executable;application/x-gtar;application/x-gzip;application/x-gzpostscript;application/x-java-archive;application/x-lha;application/x-lhz;application/x-lrzip;application/x-lrzip-compressed-tar;application/x-lz4;application/x-lzip;application/x-lzip-compressed-tar;application/x-lzma;application/x-lzma-compressed-tar;application/x-lzop;application/x-lz4-compressed-tar;application/x-ms-wim;application/x-rar;application/x-rar-compressed;application/x-rpm;application/x-source-rpm;application/x-rzip;application/x-rzip-compressed-tar;application/x-tar;application/x-tarz;application/x-tzo;application/x-stuffit;application/x-war;application/x-xar;application/x-xz;application/x-xz-compressed-tar;application/x-zip;application/x-zip-compressed;application/x-zstd-compressed-tar;application/x-zoo;application/zip;application/zstd;
  '';
}
