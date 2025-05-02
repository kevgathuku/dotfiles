return {
	{
		"rafamadriz/neon",
		config = function()
			-- vim.g.neon_style = "default"
			vim.o.termguicolors = true
			-- vim.cmd[[colorscheme neon]]
		end,
	},
	{
		"catppuccin/nvim",
		config = function()
			require("catppuccin").setup({
				flavour = "mocha", -- latte, frappe, macchiato, mocha
				background = {
					light = "latte",
					dark = "mocha",
				},
			})
			vim.cmd.colorscheme("catppuccin")
		end,
	},
}
