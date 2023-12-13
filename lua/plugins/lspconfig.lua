---@type LazySpec
return {
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = {
      {
        -- TODO add ensure installed
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
        hls = function ()
        end,
        clangd = function ()
          require('lspconfig').clangd.setup {
            capabilities = require('cmp_nvim_lsp').default_capabilities(),
            on_attach = function ()
              require('clangd_extensions.inlay_hints').setup_autocmd()
              require('clangd_extensions.inlay_hints').set_inlay_hints()
            end
          }
        end
      },
    },
    event = 'BufReadPre',
    cmd = {
      'LspInstall',
      'LspUninstall',
    },
  },
}
