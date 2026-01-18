{pkgs, ...}: let
  browser = "brave";
  terminal = "ghostty";
  file = "nemo";
in {
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
    plugins = [
      pkgs.hyprlandPlugins.hyprexpo
    ];
    systemd.enable = true;
    settings = {
      plugin = {
        hyprexpo = {
          columns = 2;
          gap_size = 5;
          bg_col = "rgb(111111)";
          workspace_method = "workspace"; # [center/first] [workspace] e.g. first 1 or center m+1
          skip_empty = true;

          gesture_distance = 300;
        };
      };
      exec-once = [
        "dbus-update-activation-environment --all --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "hyprpanel &"

        "hyprlock"

        "nm-applet &"
        "poweralertd &"

        "wl-clip-persist --clipboard both &"
        "wl-paste --watch cliphist store &"
        "hyprctl setcursor Bibata-Modern-Ice 24 &"
        "swww-daemon &"

        "podman-desktop &"

        "${terminal} --gtk-single-instance=true --quit-after-last-window-closed=false --initial-window=false"

        "sh -c 'sleep 5 && twinkle'"
      ];

      input = {
        kb_layout = "ch";
        kb_options = "grp:alt_caps_toggle";
        numlock_by_default = true;
        repeat_delay = 300;
        follow_mouse = 0;
        float_switch_override_focus = 0;
        mouse_refocus = 0;
        sensitivity = 0;
        touchpad = {
          natural_scroll = true;
        };
      };

      general = {
        "$mainMod" = "SUPER";
        layout = "dwindle";
        gaps_in = 2;
        gaps_out = 4;
        border_size = 2;
        "col.active_border" = "rgb(ACB5F2) rgb(E6B5D8) 45deg";
        "col.inactive_border" = "0x00000000";
        # border_part_of_window = false;
        no_border_on_floating = false;
      };

      misc = {
        disable_autoreload = true;
        disable_hyprland_logo = true;
        always_follow_on_dnd = true;
        layers_hog_keyboard_focus = true;
        animate_manual_resizes = false;
        enable_swallow = true;
        focus_on_activate = true;
        new_window_takes_over_fullscreen = 2;
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
          size = 3;
          passes = 2;
          brightness = 1;
          contrast = 1.4;
          ignore_opacity = true;
          noise = 0;
          new_optimizations = true;
          xray = true;
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

        "$mainMod, V, hyprexpo:expo, toggle"

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
        ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"

        "$mainMod, mouse_down, workspace, e-1"
        "$mainMod, mouse_up, workspace, e+1"

        # clipboard manager
        "$mainMod, M, exec, cliphist list | rofi -dmenu -theme-str 'window {width: 50%;} listview {columns: 1;}' | cliphist decode | wl-copy"
      ];

      # mouse binding
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      # windowrule
      windowrule = [
        "noborder, onworkspace:1"
        "float,class:^(peazip)$"
        "float,class:^(Viewnior)$"
        "float,class:^(imv)$"
        "float,class:^(mpv)$"
        "tile,class:^(Aseprite)$"
        "float,class:^(Audacious)$"
        "pin,class:^(rofi)$"
        "pin,class:^(waypaper)$"
        # "idleinhibit focus,mpv"
        # "float,udiskie"
        "float,title:^(Transmission)$"
        "float,title:^(Volume Control)$"
        "float,title:^(Firefox — Sharing Indicator)$"
        "move 0 0,title:^(Firefox — Sharing Indicator)$"
        "size 700 450,title:^(Volume Control)$"
        "move 40 55%,title:^(Volume Control)$"

        "float, title:^(Picture-in-Picture)$"
        "opacity 1.0 override 1.0 override, title:^(Picture-in-Picture)$"
        "pin, title:^(Picture-in-Picture)$"
        "opacity 1.0 override 1.0 override, title:^(.*imv.*)$"
        "opacity 1.0 override 1.0 override, title:^(.*mpv.*)$"
        "opacity 1.0 override 1.0 override, class:(Aseprite)"
        "opacity 1.0 override 1.0 override, class:(Unity)"
        "opacity 1.0 override 1.0 override, class:(zen)"
        "opacity 1.0 override 1.0 override, class:(evince)"
        "workspace 1, class:^(${browser})$"
        "workspace 3, class:^(evince)$"
        "workspace 4, class:^(Gimp-2.10)$"
        "workspace 4, class:^(Aseprite)$"
        "workspace 5, class:^(Audacious)$"
        "workspace 5, class:^(Spotify)$"
        "workspace 8, class:^(com.obsproject.Studio)$"
        "workspace 10, class:^(discord)$"
        "workspace 10, class:^(WebCord)$"
        "idleinhibit focus, class:^(mpv)$"
        "idleinhibit fullscreen, class:^(firefox)$"
        "float,class:^(org.gnome.Calculator)$"
        "float,class:^(waypaper)$"
        "float,center,class:^(zenity)$"
        "size 850 500,class:^(zenity)$"
        "size 725 330,class:^(SoundWireServer)$"
        "float,class:^(org.gnome.FileRoller)$"
        "float,class:^(org.pulseaudio.pavucontrol)$"
        "float,class:^(SoundWireServer)$"
        "float,class:^(.sameboy-wrapped)$"
        "float,center,class:^(file_progress)$"
        "float,center,class:^(confirm)$"
        "float,center,class:^(dialog)$"
        "float,center,class:^(download)$"
        "float,class:^(notification)$"
        "float,center,class:^(error)$"
        "float,center,class:^(confirmreset)$"
        "float,center,title:^(Open File)$"
        "float,center,title:^(File Upload)$"
        "float,center,title:^(branchdialog)$"
        "float,center,title:^(Confirm to replace files)$"
        "float,center,title:^(File Operation Progress)$"
        "float,center,title:^(Bitwarden)$"
        "float,center,class:^(xdg-desktop-portal-gtk)$"
        "size 850 500,class:^(xdg-desktop-portal-gtk)$"

        "opacity 0.0 override,class:^(xwaylandvideobridge)$"
        "noanim,class:^(xwaylandvideobridge)$"
        "noinitialfocus,class:^(xwaylandvideobridge)$"
        "maxsize 1 1,class:^(xwaylandvideobridge)$"
        "noblur,class:^(xwaylandvideobridge)$"

        # "maxsize 1111 700, floating: 1"
        # "center, floating: 1"

        # Remove context menu transparency in chromium based apps
        "opaque,class:^()$,title:^()$"
        "noshadow,class:^()$,title:^()$"
        "noblur,class:^()$,title:^()$"

        "bordersize 0, floating:0, onworkspace:w[tv1]s[false]"
        "rounding 0, floating:0, onworkspace:w[tv1]s[false]"
        "bordersize 0, floating:0, onworkspace:f[1]s[false]"
        "rounding 0, floating:0, onworkspace:f[1]s[false]"
      ];

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
