return {
  {
    -- TODO: optional dependecies:
    --    - dot from graphviz
    --    - lldb or codelldb and nvim-dap
    -- TODO: vim.cmd.RustLsp('codeAction') supports grouping
    'mrcjkb/rustaceanvim',
    version = '^4',
    ft = { 'rust' },
  },
}
