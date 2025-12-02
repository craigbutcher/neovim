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
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return {
            timeout_ms = 500,
            lsp_format = 'fallback',
          }
        end
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        -- Conform can also run multiple formatters sequentially
        -- python = { "isort", "black" },
        --
        -- You can use 'stop_after_first' to run the first available formatter from the list
        -- javascript = { "prettierd", "prettier", stop_after_first = true },
        css = { 'prettier' },
        json = { 'prettier' },
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
  },
}
