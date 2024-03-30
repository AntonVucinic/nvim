return {
  {
    'mrcjkb/haskell-tools.nvim',
    version = '^3',
    ft = { 'haskell', 'lhaskell', 'cabal', 'cabalproject' },
    dependencies = {
      'hrsh7th/nvim-cmp',
      -- TODO: nvim-lsp-selection-range, nvim-ufo
    },
  },
  'mrcjkb/haskell-snippets.nvim',
}
