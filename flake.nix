{
  description = "Unleash the Beast";

  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    fleet-orbit = {
      url = "github:adamcik/fleet-nixos";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = {...} @ inputs: let
    theme = {
      profile = "${./assets/profile.png}";
      wallpaper = "${./assets/white.jpg}";
      lockpaper = "${./assets/white.jpg}";
      bootloader = "${./assets/bootloader.png}";
    };
  in {
    nixosModules.default = {lib, ...}: rec {
      imports = [
        inputs.home-manager.nixosModules.home-manager
        ./modules/core
        inputs.fleet-orbit.nixosModules.fleet-nixos
        ./modules/informaticon
      ];
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
        };
      };

      _module.args = {
        inherit theme;
        home = inputs.home-manager;
        stable = inputs.nixpkgs-stable.legacyPackages.${options.beast.system};
        unstable = inputs.nixpkgs-unstable.legacyPackages.${options.beast.system};
      };
    };
  };
}
