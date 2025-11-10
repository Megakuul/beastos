{pkgs, ...}: let
  version = "unstable-2024-20-11";
  rev = "323e4406e544c39ca8352be578e169582a71b1d7";
  hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  twinkle = pkgs.stdenv.mkDerivation {
    inherit version;
    pname = "twinkle";
    src = pkgs.fetchFromGitHub {
      inherit rev hash;
      owner = "LinusMoser";
      repo = "twinkle";
    };

    buildInputs = with pkgs; [
      libxml2
      file # libmagic
      libsndfile
      readline
      ucommon
      ccrtp
      qtbase
      qttools
      qtquickcontrols2
      alsa-lib
      speex
      ilbc
    ];

    nativeBuildInputs = with pkgs; [
      cmake
      bison
      flex
      bcg729
    ];

    cmakeFlags = [
      "-DWITH_G729=On"
      "-DWITH_SPEEX=On"
      "-DWITH_ILBC=On"
      "-DHAVE_LIBATOMIC=atomic"
      # "-DWITH_DIAMONDCARD=On" seems ancient and broken
    ];
  };
in {
  home.packages = [twinkle];
}
