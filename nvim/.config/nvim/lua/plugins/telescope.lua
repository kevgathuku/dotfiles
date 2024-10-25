return {
	{ "junegunn/fzf" },
	{ "junegunn/fzf.vim" },
	{
		"nvim-telescope/telescope-ui-select.nvim",
	},
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local telescope = require("telescope")
			local builtin = require("telescope.builtin")

			vim.keymap.set("n", "<C-p>", "<cmd>Telescope find_files hidden=true<cr>", {})

			telescope.setup({
				defaults = {
					hidden = true,
					vimgrep_arguments = {
						"rg",
						"--color=never",
						"--no-heading",
						"--line-number",
						"--column",
						"--smart-case",
						"--hidden", -- Include hidden files
						"--glob",
						"!.git/*", -- Exclude .git directory
					},
				},
				pickers = {
					find_files = {
						-- `hidden = true` will still show the inside of `.git/` as it's not
						--                   `.gitignore`d.
						find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
					},
				},
			})

			require("telescope").load_extension("ui-select")
		end,
	},
}
