-- print("Building my nvim config from scratch, thanks teej!")

require("config.lazy")

vim.opt.shiftwidth = 4
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.clipboard = "unnamedplus"
vim.opt.conceallevel = 1
vim.opt.signcolumn = "yes:1"

local set = vim.keymap.set

-- Escape the Terminal Mode with two taps on the esc key
set("t", "<esc><esc>", "<c-\\><c-n>")

set("n", "<space><space>x", "<cmd>source %<CR>")
set("n", "<space>x", ":.lua<CR>")
set("v", "<space>x", ":lua<CR>")

-- Control + Vim-Motion to navigate between splits
set("n", "<c-j>", "<c-w><c-j>")
set("n", "<c-k>", "<c-w><c-k>")
set("n", "<c-l>", "<c-w><c-l>")
set("n", "<c-h>", "<c-w><c-h>")

set("n", "<M-j>", "<cmd>cnext<CR>")
set("n", "<M-k>", "<cmd>cprev<CR>")

-- See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup('custom-term-open', { clear = true }),
  callback = function()
    vim.opt.number = false
    vim.opt.relativenumber = false
  end,
})

local job_id = 0
set("n", "<space>to", function()
  vim.cmd.new()
  vim.cmd.term()
  vim.cmd.wincmd("J")
  vim.api.nvim_win_set_height(0, 10)

  job_id = vim.bo.channel
end)

set("n", "<space>ef", function()
  vim.fn.chansend(job_id, { string.format('python %s\r\n', vim.fn.expand('%')) })
end)

set("n", "-", "<cmd>Oil<CR>")
