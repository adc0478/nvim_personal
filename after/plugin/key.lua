
local map = vim.api.nvim_set_keymap

local opts = { noremap = true, silent = true }

vim.keymap.set('n','<leader>w',"<cmd>:w<Cr>",opts)
vim.keymap.set('n','<leader>b',"<cmd>:BuffergatorToggle<Cr>",opts)
vim.keymap.set('n','<C-q>',"<cmd>:q<Cr>",opts)
vim.keymap.set('n','<leader>nt',"<cmd>:NERDTreeFind<Cr>",opts)
vim.keymap.set("n", "<S-Up>", ":resize +2<CR>", opts)
vim.keymap.set("n", "<S-Down>", ":resize -2<CR>", opts)
vim.keymap.set("n", "<C-Right>", ":vertical resize -2<CR>", opts)
vim.keymap.set("n", "<C-Left>", ":vertical resize +2<CR>", opts)
