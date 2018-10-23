" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.local/share/nvim/plugged')
" Make sure you use single quotes
Plug 'neovimhaskell/haskell-vim'
Plug 'junegunn/fzf', {'dir': '~/.fzf', 'do': './install --bin'}
Plug 'junegunn/fzf.vim'
" Plug 'ndmitchell/ghcid', {'rtp': 'plugins/nvim'}
Plug 'scrooloose/nerdtree'
call plug#end()

syntax on
filetype plugin indent on

set nocompatible
set number
set showmode
set smartcase
set smarttab
" set smartindent
set autoindent
set expandtab
set shiftwidth=2
set softtabstop=2
set background=dark
set laststatus=0

" " Color settings
" colo darkblue
" hi Keyword ctermfg=darkcyan
" hi Constant ctermfg=5*
" hi Comment ctermfg=2*
" hi Normal ctermbg=none
" hi LineNr ctermfg=darkgrey

" NERDTree Toggle
map <C-n> :NERDTreeToggle<CR>
 
" " haskell-vim
" let g:haskell_classic_highlighting = 1
" let g:haskell_indent_if = 3
" let g:haskell_indent_case = 2
" let g:haskell_indent_let = 4
" let g:haskell_indent_where = 6
" let g:haskell_indent_before_where = 2
" let g:haskell_indent_after_bare_where = 2
" let g:haskell_indent_do = 3
" let g:haskell_indent_in = 1
" let g:haskell_indent_guard = 2
" let g:haskell_indent_case_alternative = 1
" let g:cabal_indent_section = 2
