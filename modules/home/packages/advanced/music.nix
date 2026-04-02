{ pkgs, inputs, ... }:
{
  home.packages = [
    pkgs.reaper
    pkgs.wineWow64Packages.full
    inputs.native-instruments.packages.${pkgs.stdenv.system}.default
  ];
}
