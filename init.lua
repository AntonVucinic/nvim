-- TODO dap
local global = vim.g
local option = vim.o

option.clipboard = 'unnamedplus'
global.clipboard = {
  name = 'WslClipboard',
  copy = {
    ['+'] = 'clip.exe',
    ['*'] = 'clip.exe',
  },
  paste = {
    ['+'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    ['*'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
  },
  cache_enabled = 0,
}

global.loaded_python3_provider = 0
global.loaded_ruby_provider = 0
global.loaded_node_provider = 0
global.loaded_perl_provider = 0

option.number = true
option.ignorecase = true
option.smartcase = true
option.signcolumn = 'number'

math.randomseed(os.time())
local random_themes = { 'habamax', 'slate' }
vim.cmd.colorscheme(random_themes[math.random(#random_themes)])

local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

global.mapleader = ' '
global.maplocalleader = ' '

require('lazy').setup({
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = {
      {
        'williamboman/mason.nvim',
        config = true,
        cmd = {
          'Mason',
          'MasonInstall',
          'MasonLog',
          'MasonUninstall',
          'MasonUninstallAll',
          'MasonUpdate',
        },
      },
      'neovim/nvim-lspconfig',
      'folke/neodev.nvim',
      'hrsh7th/nvim-cmp',
    },
    opts = {
      handlers = {
        function(server_name)
          require('lspconfig')[server_name].setup {
            capabilities = require('cmp_nvim_lsp').default_capabilities(),
          }
        end,
        lua_ls = function()
          require('neodev').setup()
          require('lspconfig').lua_ls.setup {
            capabilities = require('cmp_nvim_lsp').default_capabilities(),
          }
        end,
      },
    },
    -- TODO lazy load (I think this won't attach to new buffers)
    event = 'BufReadPre',
    cmd = {
      'LspInstall',
      'LspUninstall',
    },
  },
  {
    -- TODO configure this completely
    'hrsh7th/nvim-cmp',
    lazy = true,
    dependencies = {
      -- TODO do I need more dependecies
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function(_, _)
      local cmp = require('cmp')
      local luasnip = require('luasnip')

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        view = {
          entries = { name = 'custom', selection_order = 'near_cursor' }
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
              -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
              -- that way you will only jump inside the snippet region
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { 'i', 's' }),

          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<C-e>'] = cmp.mapping.abort(),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }, {
          { name = 'buffer' },
        })
      }
    end,
  },
  {
    -- TODO figure this out completely
    -- TODO add a theme that actually supports this
    -- TODO add sorter
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = 'BufReadPre',
  },
  {
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
}, {
  ui = {
    icons = {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<Leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<Leader>q', vim.diagnostic.setloclist)

vim.keymap.set('n', '<Esc>', ':noh<CR>')

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<Leader>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<Leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<Leader>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<Leader>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<Leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<Leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<Leader>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})
-- require('random').setup()
--[[ vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
  callback = function (_)
    require('code_action_utils').code_action_listener()
  end
}) ]]
