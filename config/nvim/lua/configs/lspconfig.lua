local nvlsp = require "nvchad.configs.lspconfig"

nvlsp.defaults()

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
  "nil_ls",
  "yamlls",
  "rust_analyzer",
  "pyright",
  "bashls",
  "buf_ls",
}

vim.lsp.config("*", {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
})

for _, lsp in ipairs(servers) do
  vim.lsp.enable(lsp)
end
