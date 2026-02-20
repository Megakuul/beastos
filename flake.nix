{
  description = "Unleash the Beast";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fleet-orbit = {
      url = "github:adamcik/fleet-nixos";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    desktop-widgets.url = "github:Megakuul/hyprland-widgets";
    whitesur-src = {
      url = "github:vinceliuice/WhiteSur-icon-theme";
      flake = false;
    };

    slimmer-icons = {
      url = "github:selimbucher/WhiteSur-steam-icons";
      flake = false;
    };
  };

  outputs =
    { ... }@inputs:
    let
      theme = {
        profile = "${./assets/profile.png}";
        wallpaper = "${./assets/white.jpg}";
        lockpaper = "${./assets/white.jpg}";
        bootloader = "${./assets/bootloader.png}";
      };
    in
    {
      nixosModules.default =
        { lib, ... }:
        {
          options.beast = {
            nixomaticon = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Enable informaticon tools";
            };
            system = lib.mkOption {
              type = lib.types.str;
              default = "x86_64-linux";
              description = "NixOS System";
            };
            host = lib.mkOption {
              type = lib.types.str;
              default = "beast";
              description = "System hostname";
            };
            profile = {
              username = lib.mkOption {
                type = lib.types.str;
                default = "localadmin";
                description = "System username";
              };
              git = {
                username = lib.mkOption {
                  type = lib.types.str;
                  description = "Git username";
                };
                email = lib.mkOption {
                  type = lib.types.str;
                  description = "Git email";
                };
              };
              windowrules = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [ ];
                description = "List of hyprland window rules";
              };
              startup = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [ ];
                description = "List of startup commands";
              };
              apps = {
                browser = lib.mkOption {
                  type = lib.types.str;
                  default = "brave";
                  description = "Default system browser";
                };
                terminal = lib.mkOption {
                  type = lib.types.str;
                  default = "ghostty";
                  description = "Default system terminal";
                };
                explorer = lib.mkOption {
                  type = lib.types.str;
                  default = "nemo";
                  description = "Default system explorer";
                };
              };
            };
          };

          imports = [
            inputs.home-manager.nixosModules.home-manager
            ./modules/core
            inputs.fleet-orbit.nixosModules.fleet-nixos
            ./modules/informaticon
          ];

          config = {
            _module.args = {
              inherit inputs theme;
            };
          };
        };
    };
}
