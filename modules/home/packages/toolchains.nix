{unstable, ...}: {
  home.packages = with unstable; [
    # lua
    lua
    stylua
    lua-language-server

    # ui tools (html, tailwind, ts, ...)
    prettierd
    vscode-langservers-extracted
    typescript
    typescript-language-server
    rustywind
    tailwindcss-language-server
    templ
    wails
    flutter

    # go
    go
    gopls

    # c / cpp
    bazel_7
    vcpkg
    conan
    cmake
    llvmPackages_21.clang
    llvmPackages_21.clang-tools
    llvmPackages_21.lld

    # ocaml
    ocaml
    opam
    dune_3
    ocamlPackages.ocaml-lsp
    ocamlformat_0_26_2

    # rust
    rustc
    cargo
    rust-analyzer

    # nix
    alejandra
    nil

    # yaml de-retarders
    yamlfmt
    yaml-language-server

    # python
    python312
    pyright
    ruff

    # bash
    bash-language-server
    shfmt
  ];
}
