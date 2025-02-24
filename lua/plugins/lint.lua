local lint = require('lint')

lint.linters_by_ft = {
  javascript = {'eslint'},
  typescript = {'eslint'},
  javascriptreact = {'eslint'},
  typescriptreact = {'eslint'},
  golang = {'golangcilint'},
}


vim.api.nvim_create_autocmd({'InsertLeave', 'BufWritePost' }, {
  callback = function ()
    local lint_status, nlint = pcall(require, 'lint')
    if lint_status then
      nlint.try_lint(nil, { ignore_errors = true })
    end
  end,
})
