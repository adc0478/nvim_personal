 -- This file can be loaded by calling `lua require('plugins')` from your init.vim
 --

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Simple plugins can be specified as strings

  -- Lazy loading:
  -- Load on specific commands
  use {'tpope/vim-dispatch', opt = true, cmd = {'Dispatch', 'Make', 'Focus', 'Start'}}

  -- Load on an autocommand event
  use {'andymass/vim-matchup', event = 'VimEnter'}

  -- Load on a combination of conditions: specific filetypes or commands
  -- Also run code after load (see the "config" key)
  use {
    'w0rp/ale',
    ft = {'sh', 'zsh', 'bash', 'c', 'cpp', 'cmake', 'html', 'markdown', 'racket', 'vim', 'tex'},
    cmd = 'ALEEnable',
    config = 'vim.cmd[[ALEEnable]]'
  }

  -- Plugins can have dependencies on other plugins
  use {
    'haorenW1025/completion-nvim',
    opt = true,
    requires = {{'hrsh7th/vim-vsnip', opt = true}, {'hrsh7th/vim-vsnip-integ', opt = true}}
  }

  -- You can specify rocks in isolation
 -- use_rocks 'penlight'
 -- use_rocks {'lua-resty-http', 'lpeg'}

    -- Plugins can have post-install/update hooks
 -- use {'iamcco/markdown-preview.nvim', run = 'cd app && yarn install', cmd = 'MarkdownPreview'}

  -- Post-install/update hook with neovim command
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use  'nvim-treesitter/playground'
  -- Post-install/update hook with call of vimscript function with argument
  use { 'glacambre/firenvim', run = function() vim.fn['firenvim#install'](0) end }

  -- Use specific branch, dependency and run lua file after load
 
  -- Use dependency and run lua function after load
  use {
    'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' },
    config = function() require('gitsigns').setup() end
  }

  -- You can specify multiple plugins in a single call
  use {'tjdevries/colorbuddy.vim', {'nvim-treesitter/nvim-treesitter', opt = true}}

  -- You can alias plugin names
  use {'dracula/vim', as = 'dracula'}

use {
  'nvim-treesitter/nvim-treesitter'
}
use {
  'nvim-lualine/lualine.nvim',
  requires = { 'kyazdani42/nvim-web-devicons', opt = true }
}
--use {
--    "williamboman/nvim-lsp-installer",
--    "neovim/nvim-lspconfig",
--}
--use{
  --'hrsh7th/nvim-cmp',
  --requires = {
   -- 'hrsh7th/cmp-nvim-lsp',
    --'hrsh7th/cmp-buffer',
    --'hrsh7th/cmp-path',
   -- 'hrsh7th/cmp-cmdline',
    --'quangnguyen30192/cmp-nvim-ultisnips'
  --}
--}
use{
  'SirVer/ultisnips',
  requires = {
   'honza/vim-snippets'
  }
}
use "EdenEast/nightfox.nvim"
use 'preservim/nerdtree'
use 'noahfrederick/vim-laravel'
use 'jwalton512/vim-blade' 
use 'kyazdani42/nvim-web-devicons'
use {'neoclide/coc.nvim', branch = 'release'}
use 'jeetsukumaran/vim-buffergator'
use 'https://github.com/kezhenxu94/vim-mysql-plugin.git'
use 'arnaud-lb/vim-php-namespace'
use '2072/PHP-Indenting-for-VIm'
use 'Yggdroot/indentLine'
use 'mattn/emmet-vim'
-- Packer
 -- Packer
 -- use({
--  "jackMort/ChatGPT.nvim",
--    config = function()
--      require("chatgpt").setup({
        -- optional configuration
 --     })
    requires = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim"
    }
use {'preservim/tagbar'}

use {'MunifTanjim/nui.nvim'}
use {
  'nvim-telescope/telescope.nvim', tag = '0.1.4',
-- or                            , branch = '0.1.x',
  requires = { {'nvim-lua/plenary.nvim'} }
}
use {'/home/ariel/.config/nvim/proyectos_plug/proyectos'}
use {'/home/ariel/.config/nvim/proyectos_plug/BD'}
use {'/home/ariel/.config/nvim/proyectos_plug/ventana'}
end)

