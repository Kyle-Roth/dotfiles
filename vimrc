" Shared vimrc for macOS, Linux and Windows (managed by dotbot)
"   macOS/Linux: ~/.vimrc  + ~/.vim     -> repo
"   Windows:     ~/_vimrc  + ~/vimfiles -> repo

set nocompatible
set encoding=utf-8
scriptencoding utf-8

" ---------------------------------------------------------------------------
" Platform and data paths
" ---------------------------------------------------------------------------
let s:is_win = has('win32')
let s:is_mac = has('mac') || has('macunix')

" Per-machine data (undo history, plugins, netrw history) lives OUTSIDE the
" dotfiles repo so it never gets committed.
"   Linux/macOS: ~/.local/state/vim     Windows: %LOCALAPPDATA%\vim
if s:is_win
  let s:data = $LOCALAPPDATA . '/vim'
else
  let s:data = (empty($XDG_STATE_HOME) ? expand('~/.local/state') : $XDG_STATE_HOME) . '/vim'
endif
if !isdirectory(s:data . '/undo')
  call mkdir(s:data . '/undo', 'p')
endif

let &undodir = s:data . '/undo'
let g:netrw_home = s:data

" ---------------------------------------------------------------------------
" Editing
" ---------------------------------------------------------------------------
filetype plugin indent on
syntax enable

set backspace=indent,eol,start  " backspace over everything (not default on Windows)
set fileformats=unix,dos        " new files use LF line endings, even on Windows
set nowrap linebreak
set showmatch                   " show matching brackets
set mouse=a
set autoindent smartindent
set tabstop=4 shiftwidth=4 expandtab
set undofile                    " persistent undo

" ---------------------------------------------------------------------------
" Display
" ---------------------------------------------------------------------------
set number relativenumber       " hybrid line numbers
set cursorline                  " highlight current line (background only, see below)
set laststatus=2                " always show the status line
"set colorcolumn=80

" ---------------------------------------------------------------------------
" Search
" ---------------------------------------------------------------------------
set incsearch ignorecase smartcase hlsearch
" Clear search highlight
nnoremap <silent> <leader>n :nohlsearch<CR>

" ---------------------------------------------------------------------------
" Reopen files at the last cursor position
" ---------------------------------------------------------------------------
augroup remember_position
  autocmd!
  autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
augroup END

" ---------------------------------------------------------------------------
" Plugins (vim-plug)
" ---------------------------------------------------------------------------
if !empty(globpath(&runtimepath, 'autoload/plug.vim'))
  call plug#begin(s:data . '/plugged')
  Plug 'ayu-theme/ayu-vim'
  Plug 'lervag/vimtex'
  call plug#end()

  " Install any missing plugins automatically on startup (needs git)
  augroup plug_auto_install
    autocmd!
    autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
          \ | PlugInstall --sync | source $MYVIMRC | endif
  augroup END
endif

" vimtex: pick a PDF viewer per OS
let g:tex_flavor = 'latex'
if s:is_mac
  let g:vimtex_view_method = 'skim'
elseif s:is_win
  let g:vimtex_view_method = 'general'
  let g:vimtex_view_general_viewer = 'SumatraPDF'
elseif executable('zathura')
  let g:vimtex_view_method = 'zathura'
endif   " otherwise vimtex's default opens PDFs with xdg-open

" ---------------------------------------------------------------------------
" Colors
" ---------------------------------------------------------------------------
" True color everywhere except terminals that can't do it
" (macOS Terminal.app and the bare Linux console).
if has('termguicolors') && $TERM_PROGRAM !=# 'Apple_Terminal' && $TERM !=# 'linux'
  set termguicolors
endif

" Overrides re-applied after any colorscheme loads
function! s:MyHighlights() abort
  " transparent background
  highlight Normal  guibg=NONE ctermbg=NONE
  highlight NonText guibg=NONE ctermbg=NONE
  " cursor line: keep the colorscheme's background, never underline
  highlight CursorLine   term=NONE cterm=NONE gui=NONE
  highlight CursorLineNr term=bold cterm=bold gui=bold
endfunction

augroup my_highlights
  autocmd!
  autocmd ColorScheme * call s:MyHighlights()
augroup END

" Light or dark theme, decided in this order:
"   1. $VIM_BACKGROUND=light|dark   (manual override, per machine)
"   2. $COLORFGBG                   (set by iTerm2, Konsole, rxvt, ...)
"   3. asking the terminal for its background color (xterm-compatible terminals)
"   4. dark
function! s:BgFromEnv() abort
  if $VIM_BACKGROUND =~? '^\(light\|dark\)$'
    return tolower($VIM_BACKGROUND)
  endif
  if $COLORFGBG =~# ';'
    let l:bg = str2nr(split($COLORFGBG, ';')[-1])
    return index([7, 15], l:bg) >= 0 ? 'light' : 'dark'
  endif
  return ''
endfunction

" Terminal reply looks like: ESC ]11;rgb:RRRR/GGGG/BBBB ESC \
function! s:BgFromResponse(resp) abort
  let l:m = matchlist(a:resp, 'rgb:\(\x\+\)/\(\x\+\)/\(\x\+\)')
  if empty(l:m)
    return ''
  endif
  let l:c = map(l:m[1:3], 'str2nr(v:val, 16) * 255 / (float2nr(pow(16, len(v:val))) - 1)')
  return (299 * l:c[0] + 587 * l:c[1] + 114 * l:c[2]) / 1000 > 128 ? 'light' : 'dark'
endfunction

function! s:ApplyColors(bg) abort
  let g:ayucolor = a:bg ==# 'light' ? 'light' : 'mirage'
  let &background = a:bg
  silent! colorscheme ayu
  call s:MyHighlights()
endfunction

function! s:OnBgResponse() abort
  if !empty(s:BgFromEnv())
    " a manual/env setting wins
    return
  endif
  let l:bg = s:BgFromResponse(v:termrbgresp)
  if !empty(l:bg) && l:bg !=# &background
    call s:ApplyColors(l:bg)
  endif
endfunction

" Older Vims lack TermResponseAll: poll for the reply for ~1s after startup.
function! s:PollBg(timer) abort
  let s:polls = get(s:, 'polls', 0) + 1
  if !empty(v:termrbgresp)
    call s:OnBgResponse()
  elseif s:polls < 10
    call timer_start(100, function('s:PollBg'))
  endif
endfunction

augroup bg_detect
  autocmd!
  if exists('##TermResponseAll')
    autocmd TermResponseAll background call s:OnBgResponse()
  elseif has('timers')
    autocmd VimEnter * call timer_start(100, function('s:PollBg'))
  endif
augroup END

let s:bg = s:BgFromEnv()
call s:ApplyColors(empty(s:bg) ? 'dark' : s:bg)

" Toggle light/dark by hand
nnoremap <silent> <leader>b :call <SID>ApplyColors(&background ==# 'dark' ? 'light' : 'dark')<CR>
