{ pkgs, inputs, ... }:
{
  home.packages = [ inputs.twinkle.packages.x86_64-linux.twinkle ];
}
