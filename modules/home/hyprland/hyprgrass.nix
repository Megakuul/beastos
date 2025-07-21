{ pkgs, ... }:
{
  home.packages = with pkgs; [ hyprlandPlugins.hyprgrass ];
}
