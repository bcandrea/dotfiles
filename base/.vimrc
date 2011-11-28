set nocompatible               " be iMproved
filetype off                   " required!

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
" required! 
Bundle 'gmarik/vundle'

Bundle 'git://github.com/vim-scripts/The-NERD-tree.git'
Bundle 'git://github.com/jistr/vim-nerdtree-tabs.git'

filetype plugin indent on     " required! 
colorscheme slate
set noautoindent
set hls is
map <C-d> <plug>NERDTreeTabsToggle<CR>
map <C-t> <ESC>:tabnew<RETURN>
set mouse=a
set ruler
set laststatus=2
set tabstop=2
set shiftwidth=2
set expandtab
set number
syntax on
let NERDTreeShowBookmarks=1
