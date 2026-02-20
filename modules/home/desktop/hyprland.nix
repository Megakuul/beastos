{
  pkgs,
  osConfig,
  ...
}:
let
  browser = osConfig.beast.profile.apps.browser;
  terminal = osConfig.beast.profile.apps.terminal;
  file = osConfig.beast.profile.apps.explorer;
in
{
  home.packages = with pkgs; [
    hyprpicker

    # screenshot utils
    grim
    slurp
    swappy

    # screenrec utils
    wf-recorder
    wl-screenrec

    # clipboard utils
    wl-clipboard
    wl-clip-persist
    cliphist

    # monitor tooling
    nwg-look
    nwg-displays
  ];
  systemd.user.targets.hyprland-session.Unit.Wants = [
    "xdg-desktop-autostart.target"
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    portalPackage = null;

    xwayland = {
      enable = true;
      # hidpi = true;
    };
    systemd.enable = true;
    settings = {
      layerrule = {
        name = "glassify-selimbar";
        blur = true;
        blur_popups = true;
        ignore_alpha = 0.1;
        "match:namespace" = "gtk4-layer-shell";
      };
      env = [
        "QT_QPA_PLATFORMTHEME,qt5ct"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
      ];
      exec-once = [
        "dbus-update-activation-environment --all --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"

        "hyprlock"

        "nm-applet &"
        "poweralertd &"

        "wl-clip-persist --clipboard both &"
        "wl-paste --watch cliphist store &"
        "hyprctl setcursor Bibata-Modern-Ice 24 &"
        "swww-daemon &"

        "desktop &"

        "${terminal} --gtk-single-instance=true --quit-after-last-window-closed=false --initial-window=false"
      ]
      ++ osConfig.beast.profile.startup;

      input = {
        kb_layout = "ch";
        kb_options = "grp:alt_caps_toggle";
        numlock_by_default = true;
        repeat_delay = 300;
        follow_mouse = 2;
        float_switch_override_focus = 0;
        mouse_refocus = 0;
        sensitivity = 0;
        touchpad = {
          natural_scroll = true;
        };
      };

      "$mainMod" = "SUPER";
      general = {
        layout = "dwindle";
        gaps_in = 2;
        gaps_out = 4;
        border_size = 2;
        "col.active_border" = "rgb(ACB5F2) rgb(E6B5D8) 45deg";
        "col.inactive_border" = "0x00000000";
      };

      misc = {
        disable_autoreload = true;
        disable_hyprland_logo = true;
        always_follow_on_dnd = true;
        layers_hog_keyboard_focus = true;
        animate_manual_resizes = false;
        enable_swallow = true;
        focus_on_activate = true;
        middle_click_paste = false;
      };

      dwindle = {
        force_split = 2;
        special_scale_factor = 1.0;
        split_width_multiplier = 1.0;
        use_active_for_splits = true;
        pseudotile = "yes";
        preserve_split = "yes";
      };

      master = {
        new_status = "master";
        special_scale_factor = 1;
      };

      decoration = {
        rounding = 0;
        active_opacity = 0.97;
        inactive_opacity = 0.94;
        # fullscreen_opacity = 1.0;

        blur = {
          enabled = true;
          size = 1;
          passes = 2;
          brightness = 1;
          contrast = 1.4;
          noise = 0;
          new_optimizations = true;
        };

        shadow = {
          enabled = true;

          ignore_window = true;
          offset = "0 2";
          range = 20;
          render_power = 3;
          color = "rgba(00000055)";
        };
      };

      animations = {
        enabled = true;

        bezier = [
          "fluent_decel, 0, 0.2, 0.4, 1"
          "easeOutCirc, 0, 0.55, 0.45, 1"
          "easeOutCubic, 0.33, 1, 0.68, 1"
          "fade_curve, 0, 0.55, 0.45, 1"
        ];

        animation = [
          # name, enable, speed, curve, style

          # Windows
          "windowsIn,   0, 4, easeOutCubic,  popin 20%" # window open
          "windowsOut,  0, 4, fluent_decel,  popin 80%" # window close.
          "windowsMove, 1, 2, fluent_decel, slide" # everything in between, moving, dragging, resizing.

          # Fade
          "fadeIn,      1, 3,   fade_curve" # fade in (open) -> layers and windows
          "fadeOut,     1, 3,   fade_curve" # fade out (close) -> layers and windows
          "fadeSwitch,  0, 1,   easeOutCirc" # fade on changing activewindow and its opacity
          "fadeShadow,  1, 10,  easeOutCirc" # fade on changing activewindow for shadows
          "fadeDim,     1, 4,   fluent_decel" # the easing of the dimming of inactive windows
          # "border,      1, 2.7, easeOutCirc"  # for animating the border's color switch speed
          # "borderangle, 1, 30,  fluent_decel, once" # for animating the border's gradient angle - styles: once (default), loop
          "workspaces,  1, 4,   easeOutCubic, fade" # styles: slide, slidevert, fade, slidefade, slidefadevert
        ];
      };

      binds = {
        movefocus_cycles_fullscreen = true;
      };

      bind = [
        "$mainMod, Q, exec, ${terminal}"
        "$mainMod, B, exec, [workspace 1 silent] ${browser}"
        "$mainMod, C, killactive,"
        "$mainMod, F, fullscreen, 1"
        "$mainMod, R, exec, rofi -show drun || pkill rofi"
        "$mainMod, W, exec, rofi -show window || pkill rofi"
        "$mainMod, S, exec, rofi -show ssh -terminal ${terminal} || pkill rofi"
        "$mainMod, G, exec, hyprlock"
        "$mainMod, P, pseudo,"
        "$mainMod, T, togglefloating"
        "$mainMod, E, exec, ${file}"

        ",Print, exec, grim -g \"$(slurp)\" - | swappy -f -"

        # switch focus
        "$mainMod, left,  movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up,    movefocus, u"
        "$mainMod, down,  movefocus, d"
        "$mainMod, h, movefocus, l"
        "$mainMod, j, movefocus, d"
        "$mainMod, k, movefocus, u"
        "$mainMod, l, movefocus, r"

        "$mainMod, left,  alterzorder, top"
        "$mainMod, right, alterzorder, top"
        "$mainMod, up,    alterzorder, top"
        "$mainMod, down,  alterzorder, top"
        "$mainMod, h, alterzorder, top"
        "$mainMod, j, alterzorder, top"
        "$mainMod, k, alterzorder, top"
        "$mainMod, l, alterzorder, top"

        "CTRL ALT, up, exec, hyprctl dispatch focuswindow floating"
        "CTRL ALT, down, exec, hyprctl dispatch focuswindow tiled"

        "$mainMod SHIFT, left, movewindow, l"
        "$mainMod SHIFT, right, movewindow, r"
        "$mainMod SHIFT, up, movewindow, u"
        "$mainMod SHIFT, down, movewindow, d"
        "$mainMod SHIFT, h, movewindow, l"
        "$mainMod SHIFT, j, movewindow, d"
        "$mainMod SHIFT, k, movewindow, u"
        "$mainMod SHIFT, l, movewindow, r"

        "$mainMod, TAB, workspace, m+1 "
        "$mainMod, SHIFT_TAB, workspace, m-1 "
        "$mainMod, U, movetoworkspacesilent, m+1 "
        "$mainMod, D, movetoworkspacesilent, m-1 "

        # media and volume controls
        # ",XF86AudioMute,exec, pamixer -t"
        ",XF86AudioPlay,exec, playerctl play-pause"
        ",XF86AudioNext,exec, playerctl next"
        ",XF86AudioPrev,exec, playerctl previous"
        ",XF86AudioStop,exec, playerctl stop"

        "$mainMod, mouse_down, workspace, e-1"
        "$mainMod, mouse_up, workspace, e+1"

        # clipboard manager
        "$mainMod, M, exec, cliphist list | rofi -dmenu -theme-str 'window {width: 50%;} listview {columns: 1;}' | cliphist decode | wl-copy"
      ];

      bindl = [
        ",XF86AudioRaiseVolume, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 && wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+ && desktop-ctl show volume"
        ",XF86AudioLowerVolume, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 && wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- && desktop-ctl show volume"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && desktop-ctl show volume"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl -e4 -n10 set 4%+ && desktop-ctl show brightness"
        ",XF86MonBrightnessDown, exec, brightnessctl -e4 -n10 set 4%- && desktop-ctl show brightness"
      ];

      # mouse binding
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      windowrule = [
        "match:class ^(peazip)$, float 1"
        "match:class ^(Viewnior)$, float 1"
        "match:class ^(imv)$, float 1"
        "match:class ^(mpv)$, float 1"
        "match:class ^(Aseprite)$, tile 1"
        "match:class ^(Audacious)$, float 1"
        "match:class ^(rofi)$, pin 1"
        "match:class ^(waypaper)$, pin 1"

        "match:title ^(Transmission)$, float 1"
        "match:title ^(Volume Control)$, float 1"
        "match:title ^(Firefox — Sharing Indicator)$, float 1"
        "match:title ^(Firefox — Sharing Indicator)$, move 0 0"
        "match:title ^(Volume Control)$, size 700 450"
        "match:title ^(Volume Control)$, move 40 55%"

        "match:title ^(Picture-in-Picture)$, float 1"
        "match:title ^(Picture-in-Picture)$, opacity 1.0 override 1.0 override"
        "match:title ^(Picture-in-Picture)$, pin 1"
        "match:title ^(.*imv.*)$, opacity 1.0 override 1.0 override"
        "match:title ^(.*mpv.*)$, opacity 1.0 override 1.0 override"
        "match:class (Aseprite), opacity 1.0 override 1.0 override"
        "match:class (Unity), opacity 1.0 override 1.0 override"
        "match:class (zen), opacity 1.0 override 1.0 override"
        "match:class (evince), opacity 1.0 override 1.0 override"
        "match:class ^(${browser})$, workspace 1"
        "match:class ^(evince)$, workspace 3"
        "match:class ^(Gimp-2.10)$, workspace 4"
        "match:class ^(Aseprite)$, workspace 4"
        "match:class ^(Audacious)$, workspace 5"
        "match:class ^(Spotify)$, workspace 5"
        "match:class ^(com.obsproject.Studio)$, workspace 8"
        "match:class ^(discord)$, workspace 10"
        "match:class ^(WebCord)$, workspace 10"

        "match:class ^(org.gnome.Calculator)$, float 1"
        "match:class ^(waypaper)$, float 1"
        "match:class ^(zenity)$, float 1, center 1"
        "match:class ^(zenity)$, size 850 500"
        "match:class ^(SoundWireServer)$, size 725 330"
        "match:class ^(org.gnome.FileRoller)$, float 1"
        "match:class ^(org.pulseaudio.pavucontrol)$, float 1"
        "match:class ^(SoundWireServer)$, float 1"
        "match:class ^(.sameboy-wrapped)$, float 1"
        "match:class ^(file_progress)$, float 1, center 1"
        "match:class ^(confirm)$, float 1, center 1"
        "match:class ^(dialog)$, float 1, center 1"
        "match:class ^(download)$, float 1, center 1"
        "match:class ^(notification)$, float 1"
        "match:class ^(error)$, float 1, center 1"
        "match:class ^(confirmreset)$, float 1, center 1"
        "match:title ^(Open File)$, float 1, center 1"
        "match:title ^(File Upload)$, float 1, center 1"
        "match:title ^(branchdialog)$, float 1, center 1"
        "match:title ^(Confirm to replace files)$, float 1, center 1"
        "match:title ^(File Operation Progress)$, float 1, center 1"
        "match:title ^(Bitwarden)$, float 1, center 1"
        "match:class ^(xdg-desktop-portal-gtk)$, float 1, center 1"
        "match:class ^(xdg-desktop-portal-gtk)$, size 850 500"

        "match:class ^(xwaylandvideobridge)$, opacity 0.0 override"
        "match:class ^(xwaylandvideobridge)$, no_anim 1"
        "match:class ^(xwaylandvideobridge)$, no_initial_focus 1"
        "match:class ^(xwaylandvideobridge)$, max_size 1 1"
        "match:class ^(xwaylandvideobridge)$, no_blur 1"

        "match:class ^()$, match:title ^()$, opaque 1"
        "match:class ^()$, match:title ^()$, no_shadow 1"
        "match:class ^()$, match:title ^()$, no_blur 1"

        "match:float 0, match:workspace w[tv1]s[false], border_size 0"
        "match:float 0, match:workspace w[tv1]s[false], rounding 0"
        "match:float 0, match:workspace f[1]s[false], border_size 0"
        "match:float 0, match:workspace f[1]s[false], rounding 0"
        "match:title ^(tray\.scss - hyprland-widgets - VSCodium)$, opacity 0.8 override"
      ]
      ++ osConfig.beast.profile.windowrules;

      workspace = [
        "w[tv1]s[false], gapsout:0, gapsin:0"
        "f[1]s[false], gapsout:0, gapsin:0"
      ];

      cursor = {
        no_hardware_cursors = true;
      };
    };

    extraConfig = "
      source = ~/.config/hypr/monitors.conf

      xwayland {
        force_zero_scaling = true
      }

      gesture = 3, horizontal, workspace,
    ";
  };
}
