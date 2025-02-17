{ config, lib, pkgs, home-manager, ... }:

{
  users.users.linus = {
    initialPassword = "letmecook";
    isNormalUser = true;
    extraGroups = [ "wheel" "libvirtd" ];
  };

  home-manager.users.linus = {
    home.stateVersion = "24.11";
    home.file.".emacs".source = ../emacs.el;
    home.file.".config/starship.toml".source = ../config/starship/config.toml;
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
      sysmacs = "emacsclient -c -a '' -nw /sudo::/etc/nixos/configuration.nix";
    };

    programs.bash.enable = true; # required to make shellAliases work.
    programs.starship.enable = true; # required to fix bash, visually.

    xdg.desktopEntries.emacs = {
      name = "Emacs";
      comment = "Unleash raw power";
      exec = "emacsclient -c -a \"\" %F";
      icon = "emacs";
      terminal = false;
      type = "Application";
      categories = [ "Development" "TextEditor" ];
      mimeType = [
        "text/english"
        "text/plain"
        "text/x-go"
        "text/x-makefile"
        "text/x-c++hdr"
        "text/x-c++src"
        "text/x-chdr"
        "text/x-csrc"
        "text/x-java"
        "text/x-moc"
        "text/x-pascal"
        "text/x-tcl"
        "text/x-tex"
        "application/x-shellscript"
        "text/x-c"
        "text/x-c++"
        "x-scheme-handler/org-protocol"
      ];
    };

    xdg.desktopEntries.emacsclient = {
      name = "Emacs (Client)";
      noDisplay = true;
    };

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "text/english" = [ "emacs.desktop" ];
        "text/x-go" = [ "emacs.desktop" ];
        "text/plain" = [ "emacs.desktop" ];
        "text/x-makefile" = [ "emacs.desktop" ];
        "text/x-c++hdr" = [ "emacs.desktop" ];
        "text/x-c++src" = [ "emacs.desktop" ];
        "text/x-chdr" = [ "emacs.desktop" ];
        "text/x-csrc" = [ "emacs.desktop" ];
        "text/x-java" = [ "emacs.desktop" ];
        "text/x-moc" = [ "emacs.desktop" ];
        "text/x-pascal" = [ "emacs.desktop" ];
        "text/x-tcl" = [ "emacs.desktop" ];
        "text/x-tex" = [ "emacs.desktop" ];
        "application/x-shellscript" = [ "emacs.desktop" ];
        "text/x-c" = [ "emacs.desktop" ];
        "text/x-c++" = [ "emacs.desktop" ];
        "x-scheme-handler/org-protocol" = [ "emacs.desktop" ];
      };
    };

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
  };
}
