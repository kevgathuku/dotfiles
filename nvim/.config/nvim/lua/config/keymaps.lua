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
