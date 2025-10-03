return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        ruby = { "rubocop" },
      },
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
          -- args = { "--auto-correct", "--stdin", "$FILENAME" },
        },
      },
    },
  },
}
