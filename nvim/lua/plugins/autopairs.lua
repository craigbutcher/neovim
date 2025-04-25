-- autopairs
-- https://github.com/windwp/nvim-autopairs

return {
  'windwp/nvim-autopairs',
  event = 'InsertEnter',
  opt = {},
  config = function()
    require('nvim-autopairs').setup {}
  end,
}
