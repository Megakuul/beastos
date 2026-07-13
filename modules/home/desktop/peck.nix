{pkgs, ...}: let
  peck = pkgs.stdenv.mkDerivation {
    pname = "peck";
    version = "0.1.2";

    src = pkgs.fetchurl {
      url = "https://github.com/codevogel/peck/releases/download/v0.1.2/peck";
      sha256 = "b595869321085361e1e687d1c6ff308b0d5eccae3ab73a3cfd18e605f2ac82a1";
    };

    unpackPhase = "true";

    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/bin/peck
      chmod +x $out/bin/peck
    '';
  };
in {
  home.packages = with pkgs; [
    peck

    # Dependencies:
    grim
    slurp
    wf-recorder
    ffmpeg
    wl-clipboard
    wayfreeze
  ];
}
