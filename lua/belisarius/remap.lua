-- mapleader and maplocalleader is in the lazy config.
-- vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set('n', '<C-c>', '"+yy', {noremap = true, silent = true})
vim.keymap.set('x', '<C-c>', '"+y', {noremap = true, silent = true})

vim.keymap.set('n', 'y', 'y', { noremap = false })
vim.keymap.set('x', 'y', 'y', { noremap = false })
