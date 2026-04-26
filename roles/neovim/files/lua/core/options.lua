vim.opt.shiftwidth = 4
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.clipboard = "unnamedplus"
vim.opt.conceallevel = 1
vim.opt.signcolumn = "yes:1"

-- See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

