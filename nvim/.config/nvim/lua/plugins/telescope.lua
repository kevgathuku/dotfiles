return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = function(_, opts)
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    -- Merge with existing LazyVim Telescope opts if any
    opts = vim.tbl_deep_extend("force", opts or {}, {
      defaults = {
        -- Use ripgrep for searching text in files
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--hidden", -- include hidden files
          "--no-ignore", -- don't respect .gitignore
          "--glob",
          "!.git/*", -- but still skip .git folder
        },
        prompt_prefix = "  ",
        selection_caret = " ",
        path_display = { "smart" },
        mappings = {
          i = {
            ["<esc>"] = actions.close,
          },
        },
        file_ignore_patterns = { "node_modules/", ".git/" },
      },

      pickers = {
        find_files = {
          -- Use rg instead of fd for consistency
          find_command = {
            "rg",
            "--files",
            "--hidden",
            "--no-ignore",
            "--glob",
            "!.git/*",
          },
          hidden = true,
          follow = true,
        },
        live_grep = {
          additional_args = function(_)
            return { "--hidden", "--no-ignore", "--glob", "!.git/*" }
          end,
        },
      },
    })

    telescope.setup(opts)
  end,
  keys = {
    -- override default LazyVim mappings if desired
    { "<leader>sf", "<cmd>Telescope find_files<cr>", desc = "Find Files (incl hidden)" },
    { "<leader>sg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep (incl hidden)" },
    { "<leader>sB", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
  },
}
