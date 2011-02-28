" Vim:set foldmarker={,} foldlevel=0 spell

" Basics
" {
    set nocompatible                " 關閉 vi 相容模式
    set background=dark             " 設定背景爲黑色系
    set noexrc                      " 不使用 .exrc
    set cpoptions=aABceFsmq          
    syntax on                       " 開啓語法高亮度顯示
" }

" General
" {
    filetype plugin indent on
    set backspace=indent,eol,start  " 讓 Backspace 鍵可用
    "set mouse=a                    " 開啓滑鼠功能
    set noerrorbells                " 關閉警示音效
    set nobackup                    " 關閉自動備份
    set autochdir                   " 自動辨識到檔案所在目錄
    set fileformats=unix            " :e ++ff=dos [Edit file again, using dos file format, 'fileformats' is ignored]
    set fileformat=unix
    set encoding=utf-8
    set fileencodings=utf-8
    set termencoding=utf-8
    set history=500                 " keep 500 lines of command line history
" }

" UI
" {
    set number                      " 顯示列（row）號
    set numberwidth=5               " 列號的位數
    "set cursorline                 " 高亮度顯示當前所在列
    "set cursorcolumn               " 高亮度顯示當前所在欄
    set hlsearch                    " highlight search
    set incsearch                   " do incremental searching
    set ruler                       " show the cursor position all the time
    set nostartofline               " leave the cursor where it was
    set showcmd                     " display incomplete commands
    set showmatch
    "colorscheme *                  " default, blue, darkblue, slate, delek ...
" }

" Text Formatting 
" {
    set expandtab                   " no real tabs
    set tabstop=4
    set shiftwidth=4                " auto-indent amount when using cindent, stuff like >> and <<
    set softtabstop=4               " when hitting tab or backspace, how many spaces should a tab be
    "set nowrap                     " do not wrap line
    "set paste
    set cindent
    set autoindent
    set smartindent
" }

" Folding
" {
    set foldenable
    set foldmethod=syntax
" }

" Mapping
" {
    " 讓 ,n 相當於使用 :new
    " :map ,n :new
    let mapleader=","
    map Q gq
    inoremap <C-U> <C-G>u<C-U>
" }

" 狀態列設定
" {
    set laststatus=2
    set statusline=%4*%<\ %1*[%F]
    set statusline+=%4*\ %5*[%{&encoding},  " encoding
    set statusline+=%{&fileformat}]%m       " file format
    set statusline+=%4*%=\ %6*%y%4*\ %3*%l%4*,\ %3*%c%4*\ \<\ %2*%P%4*\ \>
    highlight User1 ctermfg=red
    highlight User2 term=underline cterm=underline ctermfg=green
    highlight User3 term=underline cterm=underline ctermfg=yellow
    highlight User4 term=underline cterm=underline ctermfg=white
    highlight User5 ctermfg=cyan
    highlight User6 ctermfg=white 
" }

" 自動補齊括號
" {
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
" }

" Javascript Folding
" {
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
" }

" Plugins Setting
" {
    " c9s simple comment
    " {
        let g:scomment_default_mapping=1
    " }

    " vim for phpDocumentor
    " {
        source ~/.vim/plugin/php-doc.vim 
        inoremap <C-P> <ESC>:call PhpDocSingle()<CR>i 
        nnoremap <C-P> :call PhpDocSingle()<CR> 
        vnoremap <C-P> :call PhpDocRange()<CR>
    " }
" }

" ------------------------------------------------------------------------- "

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
" Also don't do it when the mark is in the first line, that is the default
" position when opening a file.
if has("autocmd")
autocmd BufReadPost *
  \ if line("'\"") > 1 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif
endif

autocmd FileType php set omnifunc=phpcomplete#CompletePHP
