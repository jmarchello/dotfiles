local lspconfig = require('lspconfig')

-- local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- lspconfig.solargraph.setup {
--   capabilities = capabilities
-- }

lspconfig.solargraph.setup({})

vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]]
