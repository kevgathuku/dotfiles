-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Move to next tab with Tab
vim.keymap.set("n", "<Tab>", "gt", { desc = "Next Tab" })

-- Move to previous tab with Shift-Tab
vim.keymap.set("n", "<S-Tab>", "gT", { desc = "Previous Tab" })

-- Colorscheme picker
vim.api.nvim_create_user_command("Colors", function()
  require("telescope.builtin").colorscheme({
    enable_preview = true, -- live preview
    layout_strategy = "vertical", -- optional: vertical layout
  })
end, { desc = "Pick Colorscheme with Telescope" })

-- Explicit copy to system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Copy to system clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>P", '"+p', { desc = "Paste from system clipboard" })

vim.keymap.set("n", "<leader>yp", function()
  vim.fn.setreg("+", vim.fn.expand("%"))
end, { desc = "Copy file path (relative)" })

-- Create :Yanks command to open yank history
vim.api.nvim_create_user_command("Yanks", function()
  -- Call yanky.nvim's telescope picker
  require("telescope").extensions.yank_history.yank_history()
end, { desc = "Show Yank History via Telescope" })

-- Exchange line up (like unimpaired [e)
vim.keymap.set("n", "[e", function()
  local count = vim.v.count1
  vim.cmd("move -" .. (count + 1))
end, { desc = "Exchange line up (unimpaired)" })

-- Exchange line down (like unimpaired)
vim.keymap.set("n", "]e", function()
  local count = vim.v.count1
  vim.cmd("move +" .. count)
end, { desc = "Exchange line down (unimpaired)" })

-- Disable arrow keys to enforce hjkl usage
vim.keymap.set("n", "<Left>", "<cmd>echoe 'Use h'<CR>", { desc = "Use h instead" })
vim.keymap.set("n", "<Right>", "<cmd>echoe 'Use l'<CR>", { desc = "Use l instead" })
vim.keymap.set("n", "<Up>", "<cmd>echoe 'Use k'<CR>", { desc = "Use k instead" })
vim.keymap.set("n", "<Down>", "<cmd>echoe 'Use j'<CR>", { desc = "Use j instead" })
