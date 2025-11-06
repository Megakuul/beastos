local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    css = { "prettierd" },
    html = { "rustywind", "prettierd" },
    javascript = { "prettierd" },
    typescript = { "prettierd" },
    json = { "prettierd" },
    templ = { "templ" },
    go = { "gofumpt" },
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
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

return options
