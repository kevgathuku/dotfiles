return {
	{
		"mhartington/formatter.nvim",
		event = "BufWrite",
		config = function()
			local util = require("formatter.util")

			vim.api.nvim_create_autocmd("BufWritePost", {
				group = vim.api.nvim_create_augroup("_formatter", { clear = true }),
				pattern = "*",
				command = "FormatWrite",
			})

			vim.api.nvim_set_keymap("n", "<leader>f", ":Format<CR>", { noremap = true, silent = true })
			vim.api.nvim_set_keymap("n", "<leader>F", ":FormatWrite<CR>", { noremap = true, silent = true })

			-- Provides the following commands:
			-- Format, FormatWrite, FormatLock, FormatWriteLock
			require("formatter").setup({
				logging = true,
				log_level = vim.log.levels.WARN,
				filetype = {
					ruby = {
						function()
							local rubocop_path
							if vim.fn.has("macunix") == 1 then
								rubocop_path = "/Users/kevin/code/ruby/kantox/kantox-flow/exe/rubocop"
							elseif vim.fn.has("unix") == 1 then
								rubocop_path = "/home/kevingathuku/workspace/kantox-flow/exe/rubocop"
							end
							return {
								exe = rubocop_path,
								args = {
									"--fix-layout",
									"--stdin",
									util.escape_path(util.get_current_buffer_file_name()),
									"-o",
									"/tmp/rubocop.log",
								},
								stdin = true,
								transform = function(text)
									table.remove(text, 1)
									return text
								end,
							}
						end,
					},
					javascript = {
						function()
							return {
								exe = "prettier",
								args = {
									"--stdin-filepath",
									util.escape_path(util.get_current_buffer_file_path()),
								},
								stdin = true,
								try_node_modules = true,
							}
						end,
					},
					["*"] = {
						require("formatter.filetypes.any").remove_trailing_whitespace,
					},
				},
			})
		end,
	},
	{
		"mhinz/vim-mix-format",
		config = function()
			-- vim mix format config
			vim.g.mix_format_on_save = 1
		end,
	},
}
