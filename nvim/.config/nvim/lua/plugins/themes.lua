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
    'maxmx03/solarized.nvim',
    lazy = false,
    priority = 1000,
    opts = {
       variant = 'spring', -- "spring" | "summer" | "autumn" | "winter"
    },
    config = function(_, opts)
      vim.o.termguicolors = true
      vim.o.background = 'dark'
      require('solarized').setup(opts)
      vim.cmd.colorscheme 'solarized'
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
			-- vim.cmd.colorscheme("catppuccin")
		end,
	},
}
