{
  description = "Unleash the Beast";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {...} @ inputs: let
    # TODO: materialize per system (for arm support)
    username = "linus";
    system = "x86_64-linux";
    unstable = inputs.nixpkgs.legacyPackages.${system};
    stable = inputs.nixpkgs-stable.legacyPackages.${system};
  in {
    nixosConfigurations = {
      desktop = inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [./hosts/desktop];
        specialArgs = {
          host = "desktop";
          home = inputs.home-manager;
          inherit username stable unstable;
        };
      };
      laptop = inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [./hosts/laptop];
        specialArgs = {
          host = "laptop";
          home = inputs.home-manager;
          inherit username stable unstable;
        };
      };
    };
  };
}
