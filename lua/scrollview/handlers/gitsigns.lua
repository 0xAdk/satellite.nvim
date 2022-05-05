local api = vim.api

local group = api.nvim_create_augroup('scrollview_gitsigns', {})

api.nvim_create_autocmd('User', {
  pattern = 'GitsignsHunkUpdate',
  group = group,
  callback = function()
    require('scrollview').refresh_bars()
  end
})

require('scrollview.handlers').register('gitsigns', function(bufnr)
  if not package.loaded.gitsigns then
    return {}
  end

  local marks = {}

  local hunks = require'gitsigns'.get_hunks(bufnr)
  for _, hunk in ipairs(hunks or {}) do
    for i = hunk.added.start, hunk.added.start+ math.max(0, hunk.added.count - 1) do
      local hl = hunk.type == 'add'    and 'GitSignsAdd' or
                 hunk.type == 'delete' and 'GitSignsDelete' or
                                           'GitSignsChange'
      marks[#marks+1] = {
        lnum = math.max(1, i),
        symbol = hunk.type == 'delete' and '-' or '│',
        highlight = hl,
        col = 0,
      }
    end
  end

  return marks
end)
