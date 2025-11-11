{
  pkgs,
  lib,
  ...
}: let
  version = "10.3.0-21";
  # obtain hash via wget $url and nix hash file $output.tar.gz.
  hash = "sha256-pnF/KRQMAcPnTj0Ni+sKKkw+H72WHf2iYVkWsWNCndc=";
  url = "https://software.sonicwall.com/NetExtender/NetExtender-linux-amd64-${version}.tar.gz";
  netextender = pkgs.stdenv.mkDerivation rec {
    inherit version;
    pname = "netextender";
    src = pkgs.fetchurl {inherit url hash;};

    nativeBuildInputs = with pkgs; [autoPatchelfHook makeWrapper];
    buildInputs = with pkgs; [openssl_legacy zlib gtk2 pango cairo xorg.libX11];

    unpackPhase = "tar -xzf $src";
    installPhase = ''
      mkdir -p $out/bin
      BIN_CLI=$(find . -type f -iname nxcli -perm -111 | head -n1)
      BIN_SVC=$(find . -type f -iname neservice -perm -111 | head -n1)
      install -Dm755 "$BIN_CLI" $out/bin/nxcli
      install -Dm755 "$BIN_SVC" $out/bin/neservice
      ln -sf nxcli $out/bin/netextender
      ln -sf neservice $out/bin/nxservice
      for exe in nxcli neservice; do
        wrapProgram $out/bin/$exe \
          --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath buildInputs}
      done
    '';
  };
in {
  environment.systemPackages = [netextender];
}
