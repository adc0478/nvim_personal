" Fixes common backspace problems
set backspace=indent,eol,start
set autoindent cindent smartindent showmatch
set mouse=a
" Speed up scrolling in Vim
set ttyfast
filetype plugin indent on
set nobackup
" Configuración para phpactor
let g:phpactor_completion_enable = 1
autocmd FileType php nmap <Leader>pf <Plug>PhpactorNavigateToFile
autocmd FileType php nmap <Leader>pc <Plug>PhpactorComplete
autocmd FileType php nmap <Leader>ps <Plug>PhpactorSignatureHelp
