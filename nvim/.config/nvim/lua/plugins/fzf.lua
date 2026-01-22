return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    files = {
      -- Include hidden AND ignored files in file finder
      fd_opts = "--type f --hidden --no-ignore --exclude .git",
    },
    grep = {
      -- Hidden files yes, but respect .gitignore (no --no-ignore)
      rg_opts = "--hidden --glob '!.git' --column --line-number --no-heading --color=always --smart-case",
    },
  },
  keys = {
    { "<C-p>", "<cmd>FzfLua files<cr>", desc = "Find files" },
    { "<leader>fg", "<cmd>FzfLua live_grep<cr>", desc = "Live grep" },
    { "<leader>fb", "<cmd>FzfLua buffers<cr>", desc = "Buffers" },
    { "<leader>fh", "<cmd>FzfLua help_tags<cr>", desc = "Help" },
    { "<leader>fr", "<cmd>FzfLua resume<cr>", desc = "Resume last" },
    { "<leader>fG", function()
      require("fzf-lua").live_grep({ rg_opts = "--hidden --no-ignore --glob '!.git' --column --line-number --no-heading --color=always --smart-case" })
    end, desc = "Grep (include ignored)" },
  },
}
