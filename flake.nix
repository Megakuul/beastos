{
  description = "Unleash the Beast";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fleet-orbit = {
      url = "github:adamcik/fleet-nixos";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {...} @ inputs: let
    username = "linus";
    system = "x86_64-linux";
    unstable = inputs.nixpkgs.legacyPackages.${system};
    stable = inputs.nixpkgs-stable.legacyPackages.${system};
    theme = {
      profile = "${./assets/profile.png}";
      wallpaper = "${./assets/white.jpg}";
      lockpaper = "${./assets/lightning.jpg}";
    };
  in {
    nixosConfigurations = {
      desktop = inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/desktop
          inputs.fleet-orbit.nixosModules.fleet-nixos
          ./modules/informaticon
        ];
        specialArgs = {
          host = "desktop";
          home = inputs.home-manager;
          inherit username stable unstable theme;
        };
      };
      laptop = inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          # todo make another entrypoint for everything so home-manager is available
          inputs.home-manager.nixosModules.home-manager
          ./hosts/laptop
          inputs.fleet-orbit.nixosModules.fleet-nixos
          ./modules/informaticon
        ];
        specialArgs = {
          host = "laptop";
          home = inputs.home-manager;
          inherit username stable unstable theme;
        };
      };
    };
  };
}
