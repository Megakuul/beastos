{ pkgs, lib, config, inputs, ... }: 

{
    home.stateVersion = "24.11";

    home.username = "linus";
    home.homeDirectory = "/home/linus";
    home.activation = {
      createMonitorConfig = ''
        if [ ! -f "$HOME/monitors.conf" ]; then
	  echo "
# Find your monitor names with: hyprctl monitors
# Use <auto> instead of <0x0> to auto-detect

# --- Side-by-Side ---
# monitor = eDP-1, preferred, 0x0, 1 # center
# monitor = DP-1, highres@highrr, -1920x0, 1 # left

# --- Above/Below ---
# monitor = eDP-1, preferred, 0x0, 1 # center
# monitor = DP-1, highres@highrr, 0x1080, 1 # bottom

# --- Mirrored (Mirror eDP-1 onto DP-1) ---
# monitor = eDP-1, preferred, auto, 1
# monitor = DP-1, preferred, auto, 1, mirror, eDP-1
	  " > "$HOME/monitors.conf"
          chmod u+w "$HOME/monitors.conf"
        fi
      '';      
    };
    
    home.file.".emacs".source = ../emacs.el;
    home.file.".config/starship.toml".source = ../config/starship/config.toml;
    home.file.".config/nvim/" = {
      source = ../config/nvim;
      recursive = true;
    };
    home.file.".config/hypr/" = {
      source = ../config/hypr;
      recursive = true;
    };
    home.file.".config/waybar/" = {
      source = ../config/waybar;
      recursive = true;
    };
    home.file.".config/rofi/" = {
      source = ../config/rofi;
      recursive = true;
    };

    home.shellAliases = {
      ll = "ls -al";
      s = "sudo";
      k = "kubectl";
      sc = "grim -g \"$(slurp)\" - | wl-copy";
      unleash = "home-manager switch --flake path:/etc/nixos#linus";
    };

    programs.bash.enable = true; # required to make shellAliases work.
    programs.starship.enable = true; # required to fix bash, visually.

    gtk = {
      enable = true;
      theme = {
        name = "Yaru-dark";
        package = pkgs.yaru-theme;
      };
      
      iconTheme = {
        name = "WhiteSur-dark";
	      package = pkgs.whitesur-icon-theme;
      };
    };

    qt = {
      enable = true;
      platformTheme.name = "qt5ct";
    };

    dconf = {
      enable = true;
      settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
        };
      };
    };
}
