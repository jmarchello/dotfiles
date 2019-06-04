" Leader
let mapleader=","

" Tabs
set expandtab
set shiftwidth=4
set softtabstop=4

" UI
syntax enable
set background=dark
" colorscheme zenburn
colorscheme gruvbox
set termguicolors
set guifont=DejaVu\ Sans\ Mono:h14
set number "show line numbers
set guioptions-=m  "remove menu bar
set guioptions-=T  "remove toolbar
set guioptions-=r  "remove right-hand scroll bar
set guioptions-=L  "remove left-hand scroll bar

" Cursor settings
if !has('nvim')
    highlight Cursor guibg=lightgreen
    highlight iCursor guifg=white guibg=gray
endif
set guicursor=n-v-c:block-Cursor
set guicursor+=i:ver25-iCursor
set guicursor+=n-v-c:blinkon0
" set guicursor+=i:blinkwait10

set colorcolumn=120

set signcolumn=yes

"Ultisnips configuration
let g:UltiSnipsUsePythonVersion = 3
let g:UltiSnipsExpandTrigger="<alt-tab>"
let g:UltiSnipsListSnippets="<c-tab>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"

" Use deoplete.
let g:deoplete#enable_at_startup = 1
" deoplete tab-complete
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

"Wrap at column 80 in Markdown files
au BufRead,BufNewFile *.md setlocal textwidth=80

" Statusline
" set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P

" netrw
let g:netrw_liststyle=3

" NERDtree
let NERDTreeShowBookmarks=1
let NERDTreeQuitOnOpen=1
let NERDTreeShowHidden=1

"
" Enable mouse use in all modes
set mouse=a
"
" Set this to the name of your terminal that supports mouse codes.
" Must be one of: xterm, xterm2, netterm, dec, jsbterm, pterm
if !has('nvim')
  set ttymouse=xterm2
  " Send more characters for redraws
  set ttyfast
endif

" neovim terminal keybindings
if has('nvim')
    tnoremap <Esc> <C-\><C-n>
    tnoremap <A-h> <C-\><C-N><C-w>h
    tnoremap <A-j> <C-\><C-N><C-w>j
    tnoremap <A-k> <C-\><C-N><C-w>k
    tnoremap <A-l> <C-\><C-N><C-w>l
    inoremap <A-h> <C-\><C-N><C-w>h
    inoremap <A-j> <C-\><C-N><C-w>j
    inoremap <A-k> <C-\><C-N><C-w>k
    inoremap <A-l> <C-\><C-N><C-w>l
endif

" window movement simplified
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

"status line
" set laststatus=2
" set ruler

" Airline settings
let g:airline#extensions#tabline#enabled = 0
" let g:airline_powerline_fonts = 1
" let g:airline_left_sep='>'
" let g:airline_right_sep='<'

"folding settings
set foldmethod=manual
" set foldmethod=indent
" set foldnestmax=10      "deepest fold is 10 levels
" set nofoldenable        "dont fold by default

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
" Plugin 'tpope/vim-surround'
Plugin 'airblade/vim-gitgutter'
Plugin 'tpope/vim-endwise'
Plugin 'bronson/vim-trailing-whitespace'
Plugin 'Yggdroot/indentLine'
" Plugin 'Raimondi/delimitMate.git'
Plugin 'mattn/emmet-vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'scrooloose/nerdtree'
Plugin 'junegunn/fzf.vim'
Plugin 'w0rp/ale'
Plugin 'SirVer/ultisnips'
Plugin 'Shougo/deoplete.nvim'
Plugin 'godlygeek/tabular'
Plugin 'ap/vim-css-color'


"" Ruby
Plugin 'tpope/vim-rails'
Plugin 'vim-ruby/vim-ruby'
Plugin 'tpope/vim-bundler'
Plugin 'tpope/vim-rvm'

"" JavaScript
Plugin 'Quramy/tsuquyomi'
Plugin 'pangloss/vim-javascript.git'
Plugin 'mxw/vim-jsx'

" " All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" Custom keybindings
" inoremap ;; <esc>

" FZF
nmap <Leader>t :FZF<CR>
nmap <Leader>b :Buffers<CR>
map <Leader>s :Snippets<CR>

" Copy current filename to clipboard
nmap ,cs :let @*=expand("%")<CR>
nmap ,cl :let @*=expand("%:p")<CR>

" cnext and cprevious
map <Leader>cn :cnext<CR>
map <Leader>cp :cprevious<CR>

" NERDtree mapping
map <Leader>e :NERDTreeFind<CR>
map <Leader>c :NERDTreeClose<CR>
let NERDTreeIgnore=['\.swp']

map <Leader>/ :noh<CR>

" Remove trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" Find TODOs and FIXMEs
command! Todo noautocmd grep /TODO\|FIXME/j ** | cw

command! -nargs=+ Grep execute 'silent grep <args>' | copen

" " use ag for grepping
" if executable('ag')
"   set grepprg=ag\ --nogroup\ --nocolor\ --vimgrep
"   set grepformat^=%f:%l:%c:%m   " file:line:column:message
" endif

let g:indentLine_conceallevel=0
set conceallevel=0

" Wildignore
set wildignore+=**/node_modules/**
set wildignore+=**/build/**

let g:ale_fixers = {
\   'javascript': [
\       'eslint',
\   ],
\}
let g:ale_fix_on_save = 1
