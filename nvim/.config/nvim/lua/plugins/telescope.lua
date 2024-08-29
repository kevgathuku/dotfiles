return {
  {
    "nvim-telescope/telescope-ui-select.nvim",
  },
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.5',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local builtin = require("telescope.builtin")
      vim.keymap.set('n', '<C-p>', '<cmd>Telescope find_files hidden=true<cr>', {})
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})

      require("telescope").load_extension("ui-select")
    end,
  }}
