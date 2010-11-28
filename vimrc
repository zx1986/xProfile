" This must be first, because it changes other options as a side effect.
set nocompatible

set number

"set cindent
"set autoindent
"set smartindent

set backspace=indent,eol,start 	" allow backspacing over everything in insert mode

set nobackup

set hlsearch
set incsearch					" do incremental searching

set history=500					" keep 500 lines of command line history

set ruler						" show the cursor position all the time
set showcmd						" display incomplete commands

set foldmethod=syntax

set bg=dark

" \t 會以 4 個空格代替
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4

" vim utf-8 編碼
set fileencodings=utf-8
set termencoding=utf-8
set enc=utf-8
set tenc=utf8

" 先設定 :map ,n :new 然後就可以使用 ,n （相當於:new）
let mapleader=","

syntax on

filetype plugin on
"filetype indent on

set completeopt=longest,menu

" AutoComplPop setting
let g:acp_completeOption = '.,w,b,u,t,i,k'
let g:acp_behaviorSnipmateLength=1

" -----------------------------------------------------------------------------

" Don't use Ex mode, use Q for formatting
"map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
"inoremap <C-U> <C-G>u<C-U>

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
"if !exists(":DiffOrig")
"  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
"		  \ | wincmd p | diffthis
"endif

if has("autocmd")
" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
" Also don't do it when the mark is in the first line, that is the default
" position when opening a file.
autocmd BufReadPost *
  \ if line("'\"") > 1 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif
endif
