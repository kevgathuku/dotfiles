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
      {
        "gm",
        function()
          -- Wait for next key and feed "m{key}" to Vim
          local char = vim.fn.getcharstr()
          vim.cmd("normal! m" .. char)
        end,
        mode = "n",
        desc = "Set mark (was 'm')",
      },
    },
  },
  {
    "gbprod/cutlass.nvim",
    opts = {
      cut_key = "m", -- Use `m` for motion-aware cut
      override_del = true, -- Make `x` use the black-hole register by default
      exclude = { "ns", "nS" }, -- Optional: exclude substitute commands
    },
    config = function(_, opts)
      require("cutlass").setup(opts)

      -- Optional: make delete/change not yank
      vim.keymap.set({ "n", "x" }, "d", '"_d', { desc = "Delete without yanking" })
      vim.keymap.set({ "n", "x" }, "c", '"_c', { desc = "Change without yanking" })
    end,
  },
}
