
" Leader
let mapleader=","

" Tabs
set expandtab
set shiftwidth=2
set softtabstop=2

" UI
" set background=dark
" colorscheme zenburn
colorscheme cobalt2
" set termguicolors
set guifont=DejaVu\ Sans\ Mono:h14
set number "show line numbers
set number relativenumber

augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

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

" Python support
let g:python3_host_prog = '/Users/jmarchello/.pyenv/versions/py3neovim/bin/python'

"Ultisnips configuration
let g:UltiSnipsUsePythonVersion = 3
let g:UltiSnipsExpandTrigger="<Leader>s"
let g:UltiSnipsListSnippets="<c-tab>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
let g:UltiSnipsSnippetsDir="~/.vim/Ultisnips/"

" " Use deoplete.
" let g:deoplete#enable_at_startup = 1
" " deoplete tab-complete
" inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

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
" set foldmethod=manual
set foldmethod=indent
set foldnestmax=10      "deepest fold is 10 levels
set nofoldenable        "dont fold by default

set nocompatible              " be iMproved, required
filetype off                  " required

"vim-jsx settings
"make jsx support work in files other than .jsx
let g:jsx_ext_required = 0

" " Add fzf
" set rtp+=/usr/local/opt/fzf

" Custom keybindings

" LeaderF
nmap <Leader>f :Leaderf --reverse file<CR>
nmap <Leader>b :Leaderf --reverse buffer<CR>

" " FZF
" nmap <Leader>t :FZF<CR>
" nmap <Leader>b :Buffers<CR>
" map <Leader>s :Snippets<CR>

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

" let g:ale_fixers = {
" \   'javascript': [
" \       'eslint',
" \   ],
" \   'ruby': [
" \       'rubocop'
" \   ],
" \}
" let g:ale_fix_on_save = 1
source ~/.vim/config/plugins.vim
source ~/.vim/config/coc.vim
