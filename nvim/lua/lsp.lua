local lspconfig = require('lspconfig')

local capabilities = require('cmp_nvim_lsp').default_capabilities()

lspconfig.solargraph.setup {
  capabilities = capabilities
}
