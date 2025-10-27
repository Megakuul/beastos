{ inputs, pkgs, ... }:
let
  orbstrike = inputs.orbstrike.packages.${pkgs.system};
in
{
  home.packages = [ orbstrike.orbstrike-client ];
}
