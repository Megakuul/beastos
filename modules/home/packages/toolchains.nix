{pkgs, ...}: {
  home.packages = with pkgs; [
    # lua
    lua
    stylua
    lua-language-server

    # ui tools (html, tailwind, ts, ...)
    nodejs_24
    bun
    deno
    prettierd
    vscode-langservers-extracted
    typescript
    typescript-language-server
    rustywind
    tailwindcss-language-server
    svelte-language-server
    templ
    wails
    flutter
    tailwindcss_4

    # go
    go
    gopls
    gotools
    delve
    gdlv

    # c / cpp
    gnumake
    bazel_7
    conan
    cmake
    gcc

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
    nixd

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
