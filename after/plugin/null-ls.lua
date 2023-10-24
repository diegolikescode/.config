local null_ls = require("null-ls")

local opts = {
	sources = {
		null_ls.builtins.formatting.gofumpt,
		null_ls.builtins.formatting.goimports,
	}
}

