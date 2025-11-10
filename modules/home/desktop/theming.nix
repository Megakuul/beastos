# let the linux desktop theming mess begin
{pkgs, ...}: let
  variant = "macchiato";
  accent = "lavender";
  kvantumThemePackage = pkgs.catppuccin-kvantum.override {
    inherit variant accent;
  };
in {
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.caskaydia-cove
    nerd-fonts.symbols-only
    twemoji-color-font
    noto-fonts-color-emoji
    fantasque-sans-mono
    maple-mono.truetype-autohint
    libsForQt5.qt5ct
    libsForQt5.qtstyleplugin-kvantum
    qt6Packages.qtstyleplugin-kvantum
  ];

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  gtk = {
    enable = true;
    font = {
      name = "Maple Mono";
      size = 12;
    };
    theme = {
      name = "Dracula";
      package = pkgs.dracula-theme;
    };
    iconTheme = {
      name = "Dracula";
      package = pkgs.dracula-icon-theme;
    };
    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 24;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style.name = "kvantum";
    style.package = kvantumThemePackage;
  };

  xdg.configFile = {
    "Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=Catppuccin-${variant}-${accent}
    '';

    "Kvantum/Catppuccin-${variant}-${accent}".source = "${kvantumThemePackage}/share/Kvantum/Catppuccin-${variant}-${accent}";
  };

  home.pointerCursor = {
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 24;
  };

  home.sessionVariables = {
    NIXOS_OZONE_WL = 1;
    __GL_GSYNC_ALLOWED = 0;
    __GL_VRR_ALLOWED = 0;
    _JAVA_AWT_WM_NONEREPARENTING = 1;
    DISABLE_QT5_COMPAT = 0;
    GDK_BACKEND = "wayland";
    ANKI_WAYLAND = 1;
    DIRENV_LOG_FORMAT = "";
    WLR_DRM_NO_ATOMIC = 1;
    QT_AUTO_SCREEN_SCALE_FACTOR = 1;
    QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
    QT_QPA_PLATFORM = "wayland";
    GTK_THEME = "Dracula";
    MOZ_ENABLE_WAYLAND = 1;
    WLR_BACKEND = "vulkan";
    WLR_RENDERER = "vulkan";
    WLR_NO_HARDWARE_CURSORS = 1;
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "Hyprland";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
    GRIMBLAST_HIDE_CURSOR = 0;
    EDITOR = "nvim";
  };
}
