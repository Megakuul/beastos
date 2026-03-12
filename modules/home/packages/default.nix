{ ... }:
{
  nixpkgs.config.allowUnfree = true;
  imports = [
    ./cli.nix
    ./dev.nix
    ./gui.nix
    ./toolchains.nix
    ./advanced
  ];
}
