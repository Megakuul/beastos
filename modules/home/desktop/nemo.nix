{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nautilus
    nautilus-python
    nautilus-open-any-terminal
    sushi
    peazip
    gvfs
    gnomeExtensions.flickernaut
    turtle
  ];
}
