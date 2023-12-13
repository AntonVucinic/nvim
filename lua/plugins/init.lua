---@type LazySpec
return {
  {
    'navarasu/onedark.nvim',
    priority = 1000,
    config = function(_, opts)
      require('onedark').setup(opts)
      require('onedark').load()
    end,
  },
  {
    -- TODO figure this out completely
    -- TODO add a theme that actually supports this
    -- TODO add sorter
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "make", "haskell" },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end
  },
  {
    -- TODO haskell isn't working because where is only indented half as much
    -- ALTERNATIVES:
    -- - NMAC427/guess-indent.nvim
    -- - zsugabubus/crazy8.nvim
    -- - ciaranm/detectindent
    -- - tpope/vim-sleuth
    'Darazaki/indent-o-matic',
    event = 'BufReadPre',
  },
  {
    -- TODO expore more pickers
    -- TODO complete all the work here dude
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        config = function(_, _)
          require('telescope').load_extension('fzf')
        end
      },
    },
    -- TODO is this require scheme slowing things down
    keys = {
      { '<Leader>ff', function() require('telescope.builtin').find_files() end },
      { '<Leader>fg', function() require('telescope.builtin').live_grep() end },
      { '<Leader>fb', function() require('telescope.builtin').buffers() end },
      { '<Leader>fh', function() require('telescope.builtin').help_tags() end },
    },
    cmd = 'Telescope',
  },
  {
    'numToStr/Comment.nvim',
    config = true,
    -- TODO make this prettier
    -- TODO improve this plugin (how are d, dd and y, yy implemented)
    keys = {
      'gcc',
      'gbc',
      {
        'gc',
        mode = { 'n', 'x' },
      },
      {
        'gb',
        mode = { 'n', 'x' },
      },
      'gco',
      'gcO',
      'gcA',
    },
  },
  {
    import = 'plugins.languages',
  },
}
