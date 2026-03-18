return {
  -- Solarized colorscheme
  {
    "maxmx03/solarized.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  },

  -- Alabaster colorscheme
  {
    "p00f/alabaster.nvim",
    lazy = false,
    priority = 1000,
  },

  -- Set default colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "alabaster",
    },
  },
}
