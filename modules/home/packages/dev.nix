{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Nix
    nixd                              # nix lsp
    nixfmt-rfc-style                  # nix formatter

    # ocaml
    ocaml
    opam
    dune_3
    ocamlPackages.ocaml-lsp
    ocamlformat_0_26_2

    # Flutter
    flutter
    gradle

    # Rust
    rustc
    cargo

    # Database
    antares


    # C / C++
    gcc
    gdb
    gef
    cmake
    gnumake
    valgrind
    llvmPackages_20.clang-tools
    flutter
    gradle
    android-tools

    # Python
    python3
    python312Packages.ipython
  ];
}
