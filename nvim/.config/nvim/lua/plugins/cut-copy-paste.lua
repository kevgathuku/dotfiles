return {
  {"svermeulen/vim-yoink",
    config = function()
      vim.keymap.set("n", "<leader>p",'<plug>(YoinkPostPasteSwapForward)')
      vim.keymap.set("n", "<leader>n",'<plug>(YoinkPostPasteSwapBack)')
      vim.keymap.set("n", "p",'<plug>(YoinkPaste_p)')
      vim.keymap.set("n", "P",'<plug>(YoinkPaste_P)')
      -- Avoid adding delete operations such as x or d or s to the yank history
      vim.g.yoinkIncludeDeleteOperations = 1
    end
  },
  {
    "gbprod/cutlass.nvim",
    opts = {
      cut_key = 'm'
    }
  }
}
