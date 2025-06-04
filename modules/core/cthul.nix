{ inputs, ... }:
{
  imports = [ inputs.cthul.nixosModules.default ];

  cthul = {
    enable = true;
    node = "node001.cluster.cthul.io";
    rune.enable = false;
    wave.enable = false;
    granit.enable = false;
    proton.enable = false;
  };
}
