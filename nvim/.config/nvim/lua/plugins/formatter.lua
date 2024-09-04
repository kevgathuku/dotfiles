return {
  "mhartington/formatter.nvim",
  event = "BufWrite",
  config = function()
    local util = require("formatter.util")

    vim.api.nvim_create_autocmd("BufWritePost", {
      group = vim.api.nvim_create_augroup("_formatter", { clear = true }),
      pattern = "*",
      command = "FormatWrite",
    })

    -- Provides the following commands:
    -- Format, FormatWrite, FormatLock, FormatWriteLock
    require("formatter").setup({
      logging = true,
      log_level = vim.log.levels.WARN,
      filetype = {
        ruby = {
          function()
            return {
              exe = "/home/kevingathuku/workspace/kantox-flow/exe/rubocop",
              args = {
                "--fix-layout",
                "--stdin",
                util.escape_path(util.get_current_buffer_file_name()),
                "-o",
                "/tmp/rubocop.log"
              },
              stdin = true,
              transform = function(text)
                table.remove(text, 1)
                return text
              end,
            }
          end,
        },
        ["*"] = {
          require("formatter.filetypes.any").remove_trailing_whitespace,
        },
      },
    })
  end,
}
