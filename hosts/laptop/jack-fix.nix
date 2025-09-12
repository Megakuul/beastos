{ config, pkgs, ... }:
let
  hdaFw = pkgs.writeTextFile {
    name = "hda-jack-retask-fw";
    destination = "/lib/firmware/hda-jack-retask.fw";
    text = ''
      # generated with hdajackretask
      [codec]
      0x14f11f87 0x1d053012 0

      [pincfg]
      0x16 0x0321413f
      0x17 0x90173160
      0x18 0x40f001f0
      0x19 0x04a19020
      0x1a 0x90a72150
      0x21 0x40f001f0
    '';
  };
in {
  hardware.firmware = [ hdaFw ];
  boot.extraModprobeConfig = ''
    options snd-hda-intel patch=hda-jack-retask.fw
  '';
}
