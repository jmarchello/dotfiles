" Leader
let mapleader=","

" Tabs
set expandtab
set shiftwidth=2
set softtabstop=2

" UI
syntax enable
" set background=light
colorscheme zenburn
set guifont=Source\ Code\ Pro:h12
set number "show line numbers

" netrw
let g:netrw_liststyle=3

" Send more characters for redraws
set ttyfast
"
" Enable mouse use in all modes
set mouse=a
"
" Set this to the name of your terminal that supports mouse codes.
" Must be one of: xterm, xterm2, netterm, dec, jsbterm, pterm
set ttymouse=xterm2

"status line
set laststatus=2
set ruler

" Syntasic settings
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_javascript_checkers = ['eslint']

"folding settings
set foldmethod=indent   "fold based on indent
set foldnestmax=10      "deepest fold is 10 levels
set nofoldenable        "dont fold by default
set foldlevel=1         "this is just what i use

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" " alternatively, pass a path where Vundle should install plugins
" "call vundle#begin('~/some/path/here')
"
" " let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'jelera/vim-javascript-syntax.git'
Plugin 'pangloss/vim-javascript.git'
Plugin 'nathanaelkane/vim-indent-guides.git'
Plugin 'terryma/vim-multiple-cursors.git'
Plugin 'wincent/command-t.git'
Plugin 'tpope/vim-commentary.git'
Plugin 'tpope/vim-fugitive.git'
Plugin 'Valloric/YouCompleteMe.git'
Plugin 'Raimondi/delimitMate.git'
Plugin 'scrooloose/syntastic.git'
Plugin 'craigemery/vim-autotag'
" " All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" Custom keybindings
