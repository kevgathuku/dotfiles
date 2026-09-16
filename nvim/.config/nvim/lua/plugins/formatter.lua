return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        ruby = { "standardrb", lsp_format = "never" },
        eruby = { "standardrb" }, -- for *.erb templates
        rake = { "standardrb" }, -- some setups detect rake files separately
        rust = { "rustfmt", lsp_format = "fallback" },
        clojure = { "cljfmt" },
        clojurescript = { "cljfmt" },
        clojurec = { "cljfmt" },
        fsharp = { "fantomas" },
        ocaml = { "ocamlformat" },
      },
    },
  },
}
