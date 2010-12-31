" This must be first, because it changes other options as a side effect.
set nocompatible

set number

set cindent
set autoindent
set smartindent
"set paste

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

" tab 分頁設定
set tabstop=8 
set softtabstop=8 
set shiftwidth=8 
set noexpandtab 

" 先設定 :map ,n :new 然後就可以使用 ,n （相當於:new）
let mapleader=","

syntax on

filetype plugin on
filetype indent on

set completeopt=longest,menu

" AutoComplPop setting
" let g:acp_completeOption = '.,w,b,u,t,i,k'
" let g:acp_behaviorSnipmateLength=1

" c9s simple comment
let g:scomment_default_mapping = 1

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

" --- status bar ---
set laststatus=2
set statusline=%4*%<\ %1*[%F]
set statusline+=%4*\ %5*[%{&encoding}, " encoding
set statusline+=%{&fileformat}]%m " file format
set statusline+=%4*%=\ %6*%y%4*\ %3*%l%4*,\ %3*%c%4*\ \<\ %2*%P%4*\ \>
highlight User1 ctermfg=red
highlight User2 term=underline cterm=underline ctermfg=green
highlight User3 term=underline cterm=underline ctermfg=yellow
highlight User4 term=underline cterm=underline ctermfg=white
highlight User5 ctermfg=cyan
highlight User6 ctermfg=white 

" --- 自動補齊括號 ---
:inoremap ( ()<ESC>i
:inoremap ) <c-r>=ClosePair(')')<CR>
:inoremap { {}<ESC>i
:inoremap } <c-r>=ClosePair('}')<CR>
:inoremap [ []<ESC>i
:inoremap ] <c-r>=ClosePair(']')<CR>
:inoremap < <><ESC>i
:inoremap > <c-r>=ClosePair('>')<CR>
:inoremap ' ''<ESC>i
:inoremap " ""<ESC>i

function ClosePair(char)
    if getline('.')[col('.') - 1] == a:char
        return "\<Right>"
    else
        return a:char
    endif
endf

" --- Javascript Folding ---
function! JavaScriptFold() 
    setl foldmethod=syntax
    setl foldlevelstart=1
    syn region foldBraces start=/{/ end=/}/ transparent fold keepend extend

    function! FoldText()
        return substitute(getline(v:foldstart), '{.*', '{...}', '')
    endfunction
    setl foldtext=FoldText()
endfunction
au FileType javascript call JavaScriptFold()
au FileType javascript setl fen

" --- jQuery syntax ---
au BufRead,BufNewFile jquery.*.js set ft=javascript syntax=jquery

" --- MathML syntax ---
au BufNewFile,BufRead *.mml setf mathml

" --- SVG syntax ---
au BufNewFile,BufRead *.svg setf svg 

" --- HTML syntax ---
au BufNewFile,BufRead *.xhtml,*.xht,*.html setf xhtml

" --- for phpDocumentor ---
source ~/.vim/plugin/php-doc.vim 
inoremap <C-P> <ESC>:call PhpDocSingle()<CR>i 
nnoremap <C-P> :call PhpDocSingle()<CR> 
vnoremap <C-P> :call PhpDocRange()<CR> 
