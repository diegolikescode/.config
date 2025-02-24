local lsp = require('lsp-zero')
local lspconfig = require('lspconfig')
local cmp = require('cmp')

local lsp_attach = function(_, bufnr)
  local opts = {buffer = bufnr}

  vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
  vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
  vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
  vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
  vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
  vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
  vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
  vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
  vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
  vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
end

lsp.extend_lspconfig({
  -- sign_text = true,
  sign_text = {
    error = '✘',
    warn = '▲',
    hint = '⚑',
    info = '»',
  },
  lsp_attach = lsp_attach,
  capabilities = require('cmp_nvim_lsp').default_capabilities()
})

require('mason').setup({})
require('mason-lspconfig').setup({
  handlers = {
    function(server_name)
      lspconfig[server_name].setup({})
    end,
    lua_ls = function()
      lspconfig.lua_ls.setup({
        on_init = function(client)
          lsp.nvim_lua_settings(client, {})
        end
      })
    end
  },
})

lspconfig.clangd.setup{
  on_attach = lsp_attach,
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
  filetypes = { 'c', 'cpp' }
}

lspconfig.cmake.setup{
  on_attach = lsp_attach,
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
}

lspconfig.gopls.setup({
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
      gofumpt = true,
    },
  },
})

lspconfig.ts_ls.setup {
  on_attach = lsp_attach,
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
  init_options = {
    preferences = {
      disableSuggestions = true
    }
  }
}

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    local params = vim.lsp.util.make_range_params()
    params.context = {only = {"source.organizeImports"}}
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 2000)
    for cid, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
          vim.lsp.util.apply_workspace_edit(r.edit, enc)
        end
      end
    end
    vim.lsp.buf.format({async = false})
  end
})


cmp.setup({
  sources = {
    {name = 'nvim_lsp'},
  },
  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['C-y'] = cmp.mapping.confirm({select=true}),
    ['C-CR'] = cmp.mapping.confirm({select=true})
    -- ['C-s'] = cmp.mapping.confirm({select=true})
  }),
})
