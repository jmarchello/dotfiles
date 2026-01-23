vim9script

# Start from the defaults
source $VIMRUNTIME/defaults.vim

# Leader
nnoremap <SPACE> <Nop>
g:mapleader = " "

# UI
set number
set nowrap
set shortmess-=S
set laststatus=2
set mouse=

# Shell
set shell=/bin/bash
set shellcmdflag=-lc

# Cursor settings
highlight Cursor guibg=lightgreen
highlight iCursor guifg=white guibg=gray

# Columns
set colorcolumn=120
hi ColorColumn ctermbg=lightgrey guibg=lightgrey

# Wrap at column 80 in Markdown files
au BufRead,BufNewFile *.md setlocal textwidth=80

# netrw
g:netrw_liststyle = 3

# Send more characters for redraws
set ttyfast

# Window movement simplified
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

def GetCurrentDir(): string
  var dir_array = split(getcwd(), '/')
  return dir_array[-1]
enddef

# Folding settings
set foldmethod=manual
set foldnestmax=10
set nofoldenable
set nocompatible

# AutoIndent
set autoindent

# Custom keybindings
def CopyRelPath()
  @+ = expand("%:p")
enddef

def CopyAbsPath()
  @+ = expand("%")
enddef

nmap ,cs CopyAbsolutePath
nmap ,cl CopyRelativePath
command! CopyRelativePath CopyRelPath()
command! CopyAbsolutePath CopyAbsPath()

# cnext and cprevious
map <Leader>cn :cnext<CR>
map <Leader>cp :cprevious<CR>

map <Leader>/ :noh<CR>
map <Leader>e :e .<CR>

# Remap go to tag
nmap <Leader>g <C-]>

# Remove trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

# Find TODOs and FIXMEs
command! -nargs=+ Grep execute 'silent grep <args>' | copen

g:indentLine_conceallevel = 0
set conceallevel=0

# Wildignore
set wildignore+=**/node_modules/**
set wildignore+=**/build/**
set wildignore+=env/**
set wildmenu
set wildoptions=pum
set path=app/**,lib/**,**
set backupdir=~/.vim/tmp

autocmd BufNewFile,BufReadPre * syntax enable

def FZF()
  var tempname = tempname()
  execute 'silent !fzf --multi | awk ''{ print $1":1:0" }'' > ' .. fnameescape(tempname)
  try
    execute 'cfile ' .. tempname
    redraw!
  finally
    delete(tempname)
  endtry
enddef

command! Files FZF()
nnoremap <leader><SPACE> :Files<cr>
