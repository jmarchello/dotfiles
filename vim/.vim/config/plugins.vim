if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
   \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
 autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/bundle')

"" General
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'ekalinin/dockerfile.vim'
" Plug 'tpope/vim-surround'
Plug 'airblade/vim-gitgutter'
" Plug 'tpope/vim-endwise'
Plug 'bronson/vim-trailing-whitespace'
Plug 'Yggdroot/indentLine'
" Plug 'Raimondi/delimitMate.git'
Plug 'mattn/emmet-vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdtree'
" Plug 'junegunn/fzf.vim'
Plug 'Yggdroot/LeaderF'
" Plug 'w0rp/ale'
" Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
" Plug 'Shougo/deoplete.nvim'
Plug 'godlygeek/tabular'
Plug 'ap/vim-css-color'
Plug 'ludovicchabant/vim-gutentags'
Plug 'ConradIrwin/vim-bracketed-paste'

"" Ruby
Plug 'tpope/vim-rails'
Plug 'vim-ruby/vim-ruby'
Plug 'tpope/vim-bundler'
Plug 'tpope/vim-rvm'

"" JavaScript
Plug 'pangloss/vim-javascript'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'maxmellon/vim-jsx-pretty'

"" Python
" Plug 'jmcantrell/vim-virtualenv'

"" Neo4j
Plug 'neo4j-contrib/cypher-vim-syntax'

call plug#end()
