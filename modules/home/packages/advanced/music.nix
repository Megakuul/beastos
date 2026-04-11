{ pkgs, inputs, ... }:
{
  home.packages = [
    pkgs.reaper
    pkgs.wineWow64Packages.staging
    pkgs.yabridgectl
    pkgs.yabridge
    pkgs.samba
    inputs.native-instruments.packages.${pkgs.stdenv.system}.default
  ];
}
