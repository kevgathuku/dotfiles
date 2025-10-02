return {
  {
    "gbprod/yanky.nvim",
    opts = {
      ring = {
        history_length = 100,
        storage = "shada", -- persistent history
      },
      system_clipboard = {
        sync_with_ring = true,
      },
    },
    keys = {
      -- replicate Yoink paste & cycle mappings
      { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Put yanked text after cursor" },
      { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Put yanked text before cursor" },
      { "<leader>p", "<Plug>(YankyCycleForward)", desc = "Cycle forward through yank history" },
      { "<leader>n", "<Plug>(YankyCycleBackward)", desc = "Cycle backward through yank history" },
    },
  },

  -- replacement for cutlass.nvim
  {
    "gbprod/cutlass.nvim",
    opts = {
      cut_key = "m", -- same as your old config
    },
  },
}

