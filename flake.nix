{
  description = "Unleash the Beast";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    hyprspace = {
      url = "github:KZDKM/Hyprspace";
      inputs.hyprland.follows = "hyprland";
    };

    hyprpicker = {
      url = "github:hyprwm/hyprpicker";
      inputs.nixpkgs.follows = "hyprland/nixpkgs";
    };

    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs = {
        hyprgraphics.follows = "hyprland/hyprgraphics";
        hyprlang.follows = "hyprland/hyprlang";
        hyprutils.follows = "hyprland/hyprutils";
        nixpkgs.follows = "hyprland/nixpkgs";
        systems.follows = "hyprland/systems";
      };
    };
  };

  outputs = {...} @ inputs: let
    # TODO: materialize per system (for arm support)
    username = "linus";
    system = "x86_64-linux";
    stable = inputs.nixpkgs-stable.legacyPackages.${system};
    hyprsuite = {
      inherit (inputs) hyprland hyprspace hyprlock hyprpicker;
    };
  in {
    nixosConfigurations = {
      desktop = inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [./hosts/desktop];
        specialArgs = {
          host = "desktop";
          home = inputs.home-manager;
          inherit username stable hyprsuite;
        };
      };
      laptop = inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [./hosts/laptop];
        specialArgs = {
          host = "laptop";
          home = inputs.home-manager;
          inherit username stable hyprsuite;
        };
      };
    };
  };
}
