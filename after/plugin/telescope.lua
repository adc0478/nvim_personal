vim.keymap.set ('n','<leader>fg',require"telescope.builtin".git_files, {remap = false})
vim.keymap.set ('n','<leader>ff',require"telescope.builtin".find_files, {remap = false})
vim.keymap.set ('n','<leader>v',require"telescope.builtin".treesitter, {remap = false})
