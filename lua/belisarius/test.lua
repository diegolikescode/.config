-- ####### REVIEW THIS THING

-- require('neotest').setup({
--   adapters = {
--     require('neotest-jest')({
--       jestCommand = 'npm test --',
--       -- jestCommand = require('neotest-jest.jest-util').getJestCommand(vim.fn.expand '%:p:h'),
--       jestConfigFile = 'custom.jest.config.ts', -- TODO: is it?
--       env = { CI = true },
--       cwd = function (path)
--         return vim.fn.getcwd()
--       end,
--       jest_test_discovery = false,
--       discovery = {
--         enabled = false
--       }
--     })
--   }
-- })

vim.keymap.set('n', 'tf', ':TestFile --coverage<CR>', { noremap = true, silent = false })
vim.keymap.set('n', 'tn', ':TestNearest --coverage<CR>', { noremap = true, silent = false })
