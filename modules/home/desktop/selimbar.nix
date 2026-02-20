{ inputs, pkgs, ... }:
{
  home.packages = [
    pkgs.brightnessctl
    inputs.desktop-widgets.packages.${pkgs.system}.default
  ];
}
