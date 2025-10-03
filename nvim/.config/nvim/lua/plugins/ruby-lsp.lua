return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        solargraph = {
          cmd = { "solargraph", "stdio" },
          -- optional tweaks:
          settings = {
            solargraph = {
              diagnostics = true,
              formatting = false, -- let conform handle formatting
            },
          },
        },
        -- Do NOT enable rubocop as LSP here
      },
    },
  },
}
