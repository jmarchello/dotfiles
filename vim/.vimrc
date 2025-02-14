
" Leader
let mapleader=","

" Tabs
set expandtab
set shiftwidth=2
set softtabstop=2

" UI
set number "show line numbers

" Cursor settings
highlight Cursor guibg=lightgreen
highlight iCursor guifg=white guibg=gray

set colorcolumn=120

set signcolumn=yes

"Wrap at column 80 in Markdown files
au BufRead,BufNewFile *.md setlocal textwidth=80

" netrw
let g:netrw_liststyle=3

"
" Enable mouse use in all modes
set mouse=a

" Set this to the name of your terminal that supports mouse codes.
" Must be one of: xterm, xterm2, netterm, dec, jsbterm, pterm
set ttymouse=xterm2
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


" Custom keybindings

" Copy current filename to clipboard
nmap ,cs :let @*=expand("%")<CR>
nmap ,cl :let @*=expand("%:p")<CR>

" cnext and cprevious
map <Leader>cn :cnext<CR>
map <Leader>cp :cprevious<CR>

map <Leader>/ :noh<CR>

" remap go to tag
nmap <Leader>g <C-]>

" Remove trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" Find TODOs and FIXMEs
" command! Todo noautocmd grep /TODO\|FIXME/j ** | cw

command! -nargs=+ Grep execute 'silent grep <args>' | copen


" use ripgrep for grepping
if executable('rg')
  set grepprg=rg\ --vimgrep
endif

let g:indentLine_conceallevel=0
set conceallevel=0

" Wildignore
set wildignore+=**/node_modules/**
set wildignore+=**/build/**
set wildignore+=env/**
