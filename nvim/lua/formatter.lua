local M = {}

--- Organize imports by requesting the standard LSP code action.
function M.organize_imports()
  local params = vim.lsp.util.make_range_params()
  params.context = { only = { 'source.organizeImports' } }
  local result = vim.lsp.buf_request_sync(0, 'textDocument/codeAction', params, 1000)
  if not result then
    return
  end
  for client_id, res in pairs(result) do
    for _, action in pairs(res.result or {}) do
      if action.edit then
        local client = vim.lsp.get_client_by_id(client_id)
        local enc = client and client.offset_encoding or 'utf-16'
        vim.lsp.util.apply_workspace_edit(action.edit, enc)
      elseif action.command then
        vim.lsp.buf.execute_command(action.command)
      end
    end
  end
end

--- Set up an autocommand to run organize_imports on save for filetypes supported by Biome.
function M.setup_autocmd()
  vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = { '*.js', '*.jsx', '*.ts', '*.tsx', '*.json' },
    callback = function()
      vim.cmd 'undojoin' -- Merge changes into the previous undo block
      M.organize_imports()
    end,
  })
end

-- Format current Lua buffer with Stylua
local function format_stylua()
  local buf = vim.api.nvim_get_current_buf()
  local filename = vim.fn.expand '%:p'
  local text = table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), '\n')
  local cmd = 'stylua --stdin-filepath ' .. vim.fn.shellescape(filename) .. ' -'
  local output = vim.fn.system(cmd, text)
  if vim.v.shell_error ~= 0 then
    vim.notify('Stylua formatting failed: ' .. output, vim.log.levels.ERROR)
  else
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(output, '\n', { trimempty = true }))
  end
end

-- Unified format-on-save function
local function format_on_save()
  local ft = vim.bo.filetype
  vim.cmd 'undojoin' -- Merge formatting changes into the previous undo block
  if ft == 'lua' then
    format_stylua()
  elseif ft == 'go' then
    local params = vim.lsp.util.make_range_params()
    params.context = { only = { 'source.organizeImports' } }
    for cid, res in pairs(vim.lsp.buf_request_sync(0, 'textDocument/codeAction', params) or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or 'utf-16'
          vim.lsp.util.apply_workspace_edit(r.edit, enc)
        end
      end
    end
    vim.lsp.buf.format { async = false }
  else
    vim.lsp.buf.format { async = false }
  end
end

-- Setup function to register the autocommand for formatting on save
function M.setup()
  vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = '*',
    callback = format_on_save,
  })
end

return M
