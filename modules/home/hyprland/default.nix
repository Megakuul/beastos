{ inputs, ... }:
{
  imports = [
    ./hyprland.nix
    ./config.nix
    ./hyprlock.nix
    ./hyprpanel.nix
    ./variables.nix
    inputs.hyprland.homeManagerModules.default
  ];
}
