return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format {
          async = true,
          lsp_format = 'fallback',
        }
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = false,

    -- SMART FORMAT-ON-SAVE:
    -- JSON: if invalid, first repair it; if valid, format normally.
    format_on_save = function(bufnr)
      local ft = vim.bo[bufnr].filetype

      if ft ~= 'json' then
        return { timeout_ms = 500, lsp_format = 'fallback' }
      end

      -- For JSON: Always try to repair first.
      return { timeout_ms = 500 }
    end,

    -- JSON FORMATTER CHAIN:
    -- Try jsonrepair → jq
    formatters_by_ft = {
      lua = { 'stylua' },
      css = { 'stylelint' },
      json = {
        'jsonrepair', -- FIX BROKEN JSON
        'jq', -- BEAUTIFY VALID JSON
        stop_after_first = true,
      },
    },

    -- Custom formatter definitions
    formatters = {
      jsonrepair = {
        command = 'jsonrepair',
        stdin = true,
        args = {},
      },
      jq = {
        command = 'jq',
        args = { '.' },
        stdin = true,
      },
      stylelint = {
        command = 'stylelint',
        args = {
          '--fix',
          '--stdin',
          '--stdin-filename',
          '$FILENAME',
        },
        stdin = true,
      },
    },
  },
}
