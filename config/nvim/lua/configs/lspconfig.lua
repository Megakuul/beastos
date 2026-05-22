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

local custom_on_attach = function(client, bufnr)
  nvlsp.on_attach(client, bufnr)

  client.server_capabilities.semanticTokensProvider = nil
end

vim.lsp.config("*", {
  on_attach = custom_on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
})

for _, lsp in ipairs(servers) do
  vim.lsp.enable(lsp)
end
