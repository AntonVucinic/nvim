---@type LazySpec
M = {
  -- TODO why won't you stop
  {
    -- TODO install hoogle localy
    -- TODO configure code lenses
    'MrcJkb/haskell-tools.nvim',
    dependencies = {
      'nvim-telescope/telescope.nvim',
      'williamboman/mason.nvim',
      -- TODO fast-tags
      -- TODO haskell-debug-adapter and nvim-dap
      'hrsh7th/nvim-cmp',
      -- TODO nvim-lsp-selection-range
      -- TODO nvim-ufo
      -- TODO toggleterm.nvim
      -- TODO iron.nvim
    },
    version = '^3', -- Recommended
    ft = { 'haskell', 'lhaskell', 'cabal', 'cabalproject' },
    config = function(_, _)
      require('telescope').load_extension('ht')
    end
  },
}

-- TODO remove stuff from hover window
vim.g.haskell_tools = {
  tools = { -- haskell-tools options
    log = {
      level = vim.log.levels.DEBUG,
    },
  },
}

return M
