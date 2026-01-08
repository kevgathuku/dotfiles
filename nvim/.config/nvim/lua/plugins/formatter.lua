return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters = {
        rubocop = {
          command = "/home/kevingathuku/workspace/kantox-flow/exe/rubocop",
          args = {
            "--fix-layout",
            "--stdin",
            "$FILENAME",
            "-o",
            "/tmp/rubocop.log",
          },
          stdin = true,
          timeout_ms = 15000, -- 15 seconds
          postprocess = function(lines)
            -- Remove the first line of output if needed
            table.remove(lines, 1)
            return lines
          end,
        },
        cljfmt = {
          command = "cljfmt",
          args = { "fix", "$FILENAME" },
          stdin = false,
        },
      },
      formatters_by_ft = {
        ruby = { "rubocop" },
        eruby = { "rubocop" }, -- for *.erb templates
        rake = { "rubocop" }, -- some setups detect rake files separately
        rust = { "rustfmt", lsp_format = "fallback" },
        clojure = { "cljfmt" },
        clojurescript = { "cljfmt" },
        clojurec = { "cljfmt" },
      },
      default_format_opts = {
        async = true,
        lsp_fallback = true,
      },
    },
  },
}
