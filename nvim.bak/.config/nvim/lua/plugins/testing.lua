return {
  "vim-test/vim-test",
  dependencies = {
    "preservim/vimux",
  },
  config = function()
    -- vim.g['test#strategy'] = 'neovim'
    vim.g['test#strategy'] = 'vimux'
  end,
  cmd = {
    "TestNearest",
    "TestFile",
    "TestSuite",
    "TestLast",
    "TestVisit",
  },
  keys = {
    { "<leader>tn", "<cmd>TestNearest<CR>" },
    { "<leader>tf", "<cmd>TestFile<CR>" },
    { "<leader>ts", "<cmd>TestSuite<CR>" },
    { "<leader>tl", "<cmd>TestLast<CR>" },
    { "<leader>tv", "<cmd>TestVisit<CR>" },
  },
}
