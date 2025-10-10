return {
  "vim-test/vim-test",
  dependencies = {
    "preservim/vimux",
  },
  config = function()
    -- vim.g['test#strategy'] = 'neovim'
    vim.g["test#strategy"] = "vimux"
    -- Use Docker container for RSpec
    vim.g["test#ruby#rspec#executable"] = "docker exec -it kantox-flow-app-1 bundle exec rspec"

    -- Add options for the RSpec runner
    vim.g["test#ruby#rspec#options"] = {
      file = "--format documentation",
    }
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
