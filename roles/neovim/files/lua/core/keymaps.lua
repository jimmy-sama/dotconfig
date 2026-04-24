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
set("n", "-", "<cmd>Oil<CR>")
