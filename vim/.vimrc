" Leader
let mapleader=","

" Tabs
set expandtab
set shiftwidth=2
set softtabstop=2

" UI
set term=screen-256color
syntax enable
" colorscheme github
colorscheme zenburn
set guifont=DejaVu\ Sans\ Mono:h14
" set number "show line numbers

" Statusline
" set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P

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
" set laststatus=2
" set ruler

" Airline settings
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='zenburn'

"folding settings
set foldmethod=indent   "fold based on indent
set foldnestmax=10      "deepest fold is 10 levels
set nofoldenable        "dont fold by default
set foldlevel=1         "this is just what i use

set nocompatible              " be iMproved, required
filetype off                  " required

"vim-jsx settings
"make jsx support work in files other than .jsx
let g:jsx_ext_required = 0

" Add fzf
set rtp+=/usr/local/opt/fzf

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" " alternatively, pass a path where Vundle should install plugins
" "call vundle#begin('~/some/path/here')
"
" " let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

"" General
Plugin 'tpope/vim-commentary.git'
Plugin 'tpope/vim-fugitive.git'
Plugin 'ekalinin/dockerfile.vim'
Plugin 'tpope/vim-surround'
Plugin 'airblade/vim-gitgutter'
Plugin 'tpope/vim-endwise'
Plugin 'bronson/vim-trailing-whitespace'
Plugin 'Yggdroot/indentLine'
Plugin 'Raimondi/delimitMate.git'
Plugin 'mattn/emmet-vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

"" Ruby
Plugin 'tpope/vim-rails'
Plugin 'vim-ruby/vim-ruby'
Plugin 'tpope/vim-bundler'

"" JavaScript
Plugin 'jelera/vim-javascript-syntax.git'
Plugin 'pangloss/vim-javascript.git'
Plugin 'mxw/vim-jsx'

" " All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" Custom keybindings
" inoremap ;; <esc>

" FZF binding
nmap <Leader>t :FZF<CR>

" Copy current filename to clipboard
nmap ,cs :let @*=expand("%")<CR>
nmap ,cl :let @*=expand("%:p")<CR>
