return {
	"nvimtools/none-ls.nvim",
	config = function()
		local null_ls = require("null-ls")
		local rubocop_path
		if vim.fn.has("macunix") == 1 then
			rubocop_path = "/Users/kevin/code/ruby/kantox/kantox-flow/exe/rubocop"
		elseif vim.fn.has("unix") == 1 then
			rubocop_path = "/home/kevingathuku/workspace/kantox-flow/exe/rubocop"
		end

		null_ls.setup({
			sources = {
				null_ls.builtins.completion.tags,
				-- NB: cargo install stylua or thru :Mason
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.prettier,
				null_ls.builtins.formatting.fantomas,
				null_ls.builtins.diagnostics.cfn_lint,
				null_ls.builtins.diagnostics.erb_lint,
				null_ls.builtins.diagnostics.rubocop.with({
					command = { rubocop_path },
				}),
			},
		})

		vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
	end,
}
