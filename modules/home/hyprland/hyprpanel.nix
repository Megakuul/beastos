{ inputs, ... }:
{
  programs.hyprpanel = {
    enabled = true;
    settings = {
  scalingPriority = "gdk";

  wallpaper = {
    image = "/home/linus/Downloads/dino.svg";
    pywal = false;
  };

  bar = {
    launcher = {
      icon = "";
      autoDetectIcon = true;
    };

    clock = {
      format = "%m-%d  %H:%M";
      icon = "⏳";
      showIcon = true;
      showTime = true;
    };

    customModules = {
      storage = {
        paths = [ "/" ];
      };
    };

    systray = {
      customIcons = {
        "spotify-client" = {
          icon = "󰓇";
          color = "#94e2d5";
        };
      };
    };
  };

  menus = {
    transition = "crossfade";
    transitionTime = 125;

    clock = {
      time = {
        military = true;
        hideSeconds = false;
      };
      weather = {
        unit = "imperial";
        enabled = false;
      };
    };

    power = {
      lowBatteryNotification = true;
    };

    dashboard = {
      powermenu = {
        avatar.image = "/home/linus/Downloads/dino.svg";
      };

      shortcuts.left = {
        shortcut1 = {
          command = "brave";
          icon = "";
          tooltip = "Brave Browser";
        };
        shortcut2 = {
          command = "remmina";
          icon = "";
          tooltip = "A3";
        };
        shortcut3 = {
          command = "code";
          icon = "";
          tooltip = "Codium";
        };
        shortcut4 = {
          command = "podman-desktop";
          icon = "";
          tooltip = "Podman";
        };
      };

      directories = {
        left = {
          directory2 = {
            command = "bash -c \"xdg-open $HOME/Documents/\"";
            label = "󱧶 Documents";
          };
          directory3 = {
            command = "bash -c \"xdg-open $HOME/Pictures/\"";
            label = "󰉏 Pictures";
          };
        };
        right = {
          directory1 = {
            command = "bash -c \"xdg-open $HOME/\"";
            label = "󱂵 Home";
          };
          directory2 = {
            command = "bash -c \"xdg-open $HOME/Documents/repos\"";
            label = "󰚝 Repos";
          };
          directory3 = {
            command = "bash -c \"xdg-open $HOME/Videos/\"";
            label = "󰉏 Videos";
          };
        };
      };
    };
  };

  theme = {
    matugen = false;

    bar = {
      floating = false;
      transparent = false;
      opacity = 98;

      menus = {
        enableShadow = false;
        opacity = 98;
      };

      buttons = {
        opacity = 95;
        background_opacity = 95;
        background_hover_opacity = 95;

        systray = {
          enableBorder = false;
        };
        dashboard = {
          enableBorder = false;
        };
      };
    };

    font = {
      name = "FiraCode Nerd Font Propo";
      label = "FiraCode Nerd Font Propo";
      weight = 500;
    };

    notification = {
      opacity = 98;
    };

    osd = {
      enable = true;
      opacity = 98;
    };
  };
    };
  };
}
