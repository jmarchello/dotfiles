" Start form the defaults
source $VIMRUNTIME/defaults.vim

" Leader
nnoremap <SPACE> <Nop>
let mapleader=" "

" UI
set number "show line numbers
set nowrap
set shortmess-=S
set laststatus=2

" Shell
set shell=/bin/bash
set shellcmdflag="-ic"

" Cursor settings
highlight Cursor guibg=lightgreen
highlight iCursor guifg=white guibg=gray

" Columns
set colorcolumn=120
hi ColorColumn ctermbg=lightgrey guibg=lightgrey

"Wrap at column 80 in Markdown files
au BufRead,BufNewFile *.md setlocal textwidth=80

" netrw
let g:netrw_liststyle=3

" Send more characters for redraws
set ttyfast

" window movement simplified
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

function GetCurrentDir()
  let dir_array = split(getcwd(), '/')
  return dir_array[-1]
endfunction

"folding settings
set foldmethod=manual
" set foldmethod=indent
set foldnestmax=10      "deepest fold is 10 levels
set nofoldenable        "dont fold by default

set nocompatible              " be iMproved, required
filetype off                  " required

" AutoIndent
set autoindent
" set cindent


" Custom keybindings

function! CopyRelPath()
	let @+ = expand("%:p")
endfunction

function! CopyAbsPath()
	let @+ = expand("%")
endfunction

" Copy current filename to clipboard
nmap ,cs CopyAbsolutePath
nmap ,cl CopyRelativePath
command! CopyRelativePath :call CopyRelPath()
command! CopyAbsolutePath :call CopyAbsPath()

" cnext and cprevious
map <Leader>cn :cnext<CR>
map <Leader>cp :cprevious<CR>

map <Leader>/ :noh<CR>
map <Leader>e :e .<CR>

" remap go to tag
nmap <Leader>g <C-]>

" Remove trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" Find TODOs and FIXMEs
" command! Todo noautocmd grep /TODO\|FIXME/j ** | cw

command! -nargs=+ Grep execute 'silent grep <args>' | copen

let g:indentLine_conceallevel=0
set conceallevel=0

" Wildignore
set wildignore+=**/node_modules/**
set wildignore+=**/build/**
set wildignore+=env/**

set wildmenu
set wildoptions=pum
set path=app/**,lib/**,**


autocmd BufNewFile,BufReadPre * syntax enable
