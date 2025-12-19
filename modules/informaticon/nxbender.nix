{
  config,
  lib,
  pkgs,
  ...
}: let
  nxbender = pkgs.python311Packages.buildPythonApplication {
    pname = "nxbender";
    version = "2025-11-13";

    src = pkgs.fetchFromGitHub {
      owner = "micha-wehrli";
      repo = "div.tool.miwe.nx-bender";
      rev = "2a72e766d8eb6102e0518bee19604c8f9c3914ab";
      hash = "sha256-73MGyQEfsOxLVK3oY0uesEEKazD2HAoldZYfHwpFRXM=";
    };

    pyproject = true;

    build-system = with pkgs.python311Packages; [
      setuptools
    ];

    nativeBuildInputs = with pkgs; [makeWrapper];

    propagatedBuildInputs = with pkgs.python311Packages; [
      configargparse
      pyroute2
      requests
      colorlog
    ];

    postInstall = ''
      wrapProgram $out/bin/nxBender --prefix PATH : ${pkgs.ppp}/bin
      ln -s $out/bin/nxBender $out/bin/nxbender

      mkdir -p $out/share/applications
      echo "
        [Desktop Entry]
        Type=Application
        Name=NxBender
        GenericName=VPN Client
        Keywords=netextender;vpn;crapware;
        Icon=network-vpn
        Categories=Network
        Exec=sh -c 'sudo nxBender -c ~/.nxbender; read'
        Terminal=true
      " > $out/share/applications/nxbender.desktop
    '';
  };
in {
  config = lib.mkIf config.beast.nixomaticon {
    environment.systemPackages = [nxbender];
  };
}
