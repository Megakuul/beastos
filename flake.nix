{
  description = "BeastOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    impermanence.url = "github:nix-community/impermanence";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, impermanence, ... }@inputs:
    let
      system = "x86_64-linux";
      username = "linus";
      pkgs = nixpkgs.legacyPackages.${system};
      pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
    in {
        nixosConfigurations = {
          desktop-01 = nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [
	            impermanence.nixosModules.impermanence
              home-manager.nixosModules.home-manager
              ./nodes/desktop-01/config.nix
            ];
            specialArgs = { inherit pkgs-unstable; };
          };
          desktop-02 = nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [
	            impermanence.nixosModules.impermanence
              home-manager.nixosModules.home-manager
              ./nodes/desktop-02/config.nix
            ];
            specialArgs = { inherit pkgs-unstable; };
          };
          desktop-03 = nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [
	            impermanence.nixosModules.impermanence
              home-manager.nixosModules.home-manager
              ./nodes/desktop-03/config.nix
            ];
            specialArgs = { inherit pkgs-unstable; };
          };
          notebook-01 = nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [
	            impermanence.nixosModules.impermanence
              home-manager.nixosModules.home-manager
              ./nodes/notebook-01/config.nix
            ];
            specialArgs = { inherit pkgs-unstable; };
          };
	        notebook-02 = nixpkgs.lib.nixosSystem {
	          inherit system;
	          modules = [
		          impermanence.nixosModules.impermanence
		          home-manager.nixosModules.home-manager
		          ./nodes/notebook-02/config.nix
	          ];
	          specialArgs = { inherit pkgs-unstable; };
	        };
        };
	homeConfigurations = {
	  linus = home-manager.lib.homeManagerConfiguration {
	  inherit pkgs;
	  extraSpecialArgs = { inherit inputs username; };
	  modules = [
	    ./users/linus.nix
	  ];

	  };
      };
};
}
