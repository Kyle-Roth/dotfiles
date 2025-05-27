" Disable compatibility with vi which can cause unexpected issues.
set nocompatible

filetype on             " enable filetype detection
filetype plugin on      " load file-specific plugins
filetype indent on      " load file-specific indentation
syntax on               " Turn syntax highlighting on.

" Highlight cursor line underneath the cursor horizontally.
set cursorline
set nowrap

" Basic usability enhancements.
set showmatch           " Show matching brackets when cursor is on them.
set mouse=a             " Enable mouse support.
set autoindent          " Enable automatic indentation.
set smartindent         " Enable smart indentation.
set tabstop=4           " Number of spaces per tab.
set shiftwidth=4        " Number of spaces for autoindent.
set expandtab           " Use spaces instead of tabs.
set undofile            " Enable persistent undo.
set undodir=~/.vim/undo-dir

" turn hybrid line numbers on
set number relativenumber
set nu rnu

" Search behavior.
set incsearch           " Incremental search.
set ignorecase          " Ignore case in search patterns.
set smartcase           " Override ignorecase if search contains uppercase.
set hlsearch            " Highlight search results.
nnoremap <silent> <leader>n :nohlsearch<CR> " Clear search highlight.

" Appearance and aesthetics.
set laststatus=2        " Always show the status line.
"set colorcolumn=80      " Show a vertical line at 80 characters.

" File management.
augroup remember_position
  autocmd!
  autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
augroup END

" VIM package manager
call plug#begin()

" List your plugins here
Plug 'ayu-theme/ayu-vim'

Plug 'lervag/vimtex'
    let g:tex_flavor='latex'
    let g:vimtex_view_method = 'skim'

call plug#end()

" Set color scheme
set termguicolors     " Enable true color support.
let ayucolor="light"  " Use the light version of the Ayu theme.
silent! colorscheme ayu

" Force transparent background
highlight Normal guibg=NONE ctermbg=NONE
highlight NonText guibg=NONE ctermbg=NONE
