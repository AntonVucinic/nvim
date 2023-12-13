local ns = vim.api.nvim_create_namespace('mypy')
-- TODO try to parse everything
local pattern = '^.-:(%d+):(%d+):(%d+):(%d+): (%a+): (.-)%s+%[(.+)]$'
local groups = { 'lnum', 'col', 'end_lnum', 'end_col', 'severity', 'message', 'code' }
local severity_map = { note = vim.diagnostic.severity.INFO, error = vim.diagnostic.severity.ERROR }

vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = '*.py',
  callback = function(_)
    local output = vim.fn.system({
      'dmypy',
      'run',
      '--timeout',
      '3600',
      '--',
      '--show-error-end',
      '--no-color-output',
      '--no-error-summary',
      '--show-absolute-path',
      -- TODO add shadow file
      'src' })

    local diagnostics = {}
    for line in output:gmatch('[^\n]+') do
      local diagnostic = vim.diagnostic.match(line, pattern, groups, severity_map)
      if diagnostic == nil then
        print(line)
        goto continue
      end

      local filename = line:match('^[^:]+')
      if diagnostics[filename] == nil then
        diagnostics[filename] = {}
      end
      diagnostic.end_col = diagnostic.end_col + 1
      table.insert(diagnostics[filename], diagnostic)

      ::continue::
    end

    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      local filename = vim.api.nvim_buf_get_name(buf)
      vim.diagnostic.set(ns, buf, diagnostics[filename] or {}, { virtual_text = true })
      diagnostics[filename] = nil
    end
  end
})
