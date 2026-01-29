return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters = {
        rubocop = {
          command = "/home/kevingathuku/workspace/kantox-flow/exe/rubocop",
          args = {
            "--server",
            "--autocorrect",
            "$FILENAME",
          },
          stdin = false,
        },
        cljfmt = {
          command = "cljfmt",
          args = { "fix", "$FILENAME" },
          stdin = false,
        },
      },
      formatters_by_ft = {
        ruby = { "rubocop", lsp_format = "never" },
        eruby = { "rubocop" }, -- for *.erb templates
        rake = { "rubocop" }, -- some setups detect rake files separately
        rust = { "rustfmt", lsp_format = "fallback" },
        clojure = { "cljfmt" },
        clojurescript = { "cljfmt" },
        clojurec = { "cljfmt" },
        ocaml = { "ocamlformat" },
      },
    },
  },
}
