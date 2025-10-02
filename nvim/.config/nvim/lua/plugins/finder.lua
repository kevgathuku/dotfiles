return {
  -- Add telescope ui-select extension
  {
    "nvim-telescope/telescope-ui-select.nvim",
    config = function()
      require("telescope").load_extension("ui-select")
    end,
  },

  -- Add telescope-fzf-native for faster fuzzy matching
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    config = function()
      require("telescope").load_extension("fzf")
    end,
  },

  -- Override telescope config
  {
    "nvim-telescope/telescope.nvim",
    opts = function(_, opts)
      local telescope = require("telescope")

      opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
        hidden = true,
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--line-number",
          "--column",
          "--smart-case",
          "--hidden", -- include hidden files
          "--glob",
          "!.git/*", -- exclude .git folder
        },
      })

      opts.pickers = vim.tbl_deep_extend("force", opts.pickers or {}, {
        find_files = {
          find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
        },
      })

      telescope.setup(opts)
    end,

    keys = {
      { "<leader>ff", "<cmd>Telescope find_files hidden=true<cr>", desc = "Find Files (hidden included)" },
      { "<C-p>", "<cmd>Telescope find_files hidden=true<cr>", desc = "Find Files (hidden included)" },
    },
  },
}
