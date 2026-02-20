# let the linux desktop theming mess begin
{ pkgs, inputs, ... }:
let
  variant = "macchiato";
  accent = "lavender";
  kvantumThemePackage = pkgs.catppuccin-kvantum.override {
    inherit variant accent;
  };
in
{
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      sansSerif = [ "Quicksand" ];
      monospace = [ "DejaVu Sans Mono" ];
    };
  };
  home.packages = with pkgs; [
    dejavu_fonts
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.caskaydia-cove
    nerd-fonts.symbols-only
    quicksand
    catppuccin-kvantum
    twemoji-color-font
    noto-fonts-color-emoji
    fantasque-sans-mono
    maple-mono.truetype-autohint
    libsForQt5.qt5ct
    libsForQt5.qtstyleplugin-kvantum
    qt6Packages.qtstyleplugin-kvantum
    nerd-fonts.iosevka
    iosevka

  ];

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  gtk = {
    enable = true;
    font = {
      name = "Quicksand";
      size = 12;
    };
    theme = {
      name = "Dracula";
      package = pkgs.dracula-theme;
    };
    iconTheme = {
      name = "WhiteSur";
      package =
        # this was not my idea please call an ambulance or @selimbucher to get rid of the pain
        (
          let
            base = pkgs.whitesur-icon-theme.override {
              alternativeIcons = true;
              boldPanelIcons = true;
            };
          in
          base.overrideAttrs (oldAttrs: {
            version = "latest";
            src = inputs.whitesur-src;
            myCustomIcons = inputs.slimmer-icons;
            dontCheckForBrokenSymlinks = true;
            postInstall = (oldAttrs.postInstall or "") + ''
              cp -rf ${inputs.slimmer-icons}/apps/* $out/share/icons/WhiteSur/apps/

              if [ -d "${inputs.slimmer-icons}/apps@2x" ]; then
                cp -rf ${inputs.slimmer-icons}/apps@2x/* $out/share/icons/WhiteSur/apps@2x/
              fi
            '';
          })
        );
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
      theme=catppuccin-${variant}-${accent}
    '';

    "Kvantum/catppuccin-${variant}-${accent}".source =
      "${kvantumThemePackage}/share/Kvantum/catppuccin-${variant}-${accent}";
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
    EDITOR = "code";
  };
}
