return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ruby_lsp = {
          init_options = {
            formatter = "standard",
            linters = { "standard" },
          },
        },
      },
    },
  },
}
