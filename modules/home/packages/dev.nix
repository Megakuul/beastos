{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nixd                              # nix lsp
    nixfmt-rfc-style                  # nix formatter

    gcc
    gdb
    gef
    cmake
    gnumake
    valgrind
    llvmPackages_20.clang-tools
    
    go
    gopls

    python3
    python312Packages.ipython
  ];
}
