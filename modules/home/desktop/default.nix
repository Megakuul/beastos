{inputs, ...}: {
  imports = [
    ./theming.nix
    ./hyprland.nix
    ./hyprlock.nix
    ./hyprpanel.nix
    ./xdg-mimes.nix
    ./rofi.nix
    ./nemo.nix
    inputs.hyprland.homeManagerModules.default
  ];
}
