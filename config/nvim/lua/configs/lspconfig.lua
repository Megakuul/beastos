local lspconfig = require "lspconfig"
local nvlsp = require "nvchad.configs.lspconfig"

nvlsp.defaults() -- loads nvchad's defaults

local servers = {
  "lua_ls",
  "html",
  "cssls",
  "ts_ls",
  "svelte",
  "tailwindcss",
  "templ",
  "gopls",
  "clangd",
  "ocamllsp",
  "yamlls",
  "rust_analyzer",
  "pyright",
  "bashls",
  "harper_ls",
}

-- lsps with default config
for _, lsp in ipairs(servers) do
  vim.lsp.config(lsp, {})
  vim.lsp.enable { lsp }
end

lspconfig.nixd.setup {
  on_attach = nvlsp.on_attach,
  capabilities = nvlsp.capabilities,
  settings = {
    nixd = {
      nixpkgs = {
        expr = "import <nixpkgs> { }",
      },
      options = {
        nixos = {
          expr = "(import <nixpkgs/nixos> { }).options",
        },
        home_manager = {
          expr = '(builtins.getFlake "github:nix-community/home-manager").lib.homeManagerConfiguration { pkgs = import <nixpkgs> {}; modules = []; }.options',
        },
      },
    },
  },
}
