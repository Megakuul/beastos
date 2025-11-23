local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    css = { "prettierd" },
    html = { "prettierd", "rustywind" },
    svelte = { "rustywind" },
    javascript = { "prettierd" },
    typescript = { "prettierd" },
    json = { "prettierd" },
    templ = { "templ" },
    go = { "goimports", "gofumpt" },
    c = { "clang_format" },
    cpp = { "clang_format" },
    ocaml = { "ocamlformat" },
    nix = { "alejandra" },
    yaml = { "yamlfmt" },
    rust = { "rustfmt" },
    python = { "ruff_fix", "ruff_organize_imports", "ruff_format" },
    bash = { "shfmt" },
  },

  format_on_save = {
    lsp_format = "first",
    timeout_ms = 500,
  },
}

return options
