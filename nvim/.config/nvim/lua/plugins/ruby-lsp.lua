return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ruby_lsp = { enabled = false },
        rubocop = { enabled = false },
        solargraph = {
          cmd = { "solargraph", "stdio" },
          settings = {
            solargraph = {
              diagnostics = true,
              formatting = false, -- let conform handle formatting
            },
          },
        },
      },
    },
  },
}
