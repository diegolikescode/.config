require('Comment').setup({
      padding = true,
      sticky = true,
      ignore = nil,
      toggler = { line = 'gl', block = 'gb' },
      opleader = { line = 'gl', block = 'gb' },
      -- extra = { above = 'gcO', below = 'gco', eol = 'gcA' },
      mappings = { basic = true, extra = true },
      pre_hook = nil,
      post_hook = nil,
})

