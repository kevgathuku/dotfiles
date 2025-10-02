return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup({
        options = {
          theme = 'gruvbox-material'
          -- theme = 'auto'
        }
      })
    end
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
      vim.o.background = 'light'
      require('solarized').setup(opts)
      -- vim.cmd.colorscheme 'solarized'
      vim.cmd.colorscheme 'retrobox'
    end,
  },
}
