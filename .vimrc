set backspace=indent,eol,start	" more powerful backspacing
ab  #s /************************************
ab  #e <space>***********************************/
set smartindent
set hls
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set number
set nowrap
set incsearch
set formatoptions+=r
set cc=80
set list
set cursorline
au FileType make set noexpandtab
au BufNewFile,BufRead *.jsm    setf javascript
au BufNewFile,BufRead *.aidl   setf java
au BufNewFile,BufRead *.webidl   setf idl
au BufRead,BufNewFile *.log set filetype=logcat
"au FileType python set noexpandtab
colorscheme koehler
runtime ftplugin/man.vim
au BufNewFile,BufRead /home/allstars/test/proj2/*        setl ts=8 sts=8 sw=8
set exrc
set modeline
execute pathogen#infect()
let g:syntastic_javascript_checker = "jshint"
filetype plugin indent on
syntax on
let c_space_errors=1
highlight RedundantSpaces ctermbg=red guibg=red
match RedundantSpaces /\s\+$\| \+\ze\t/

set wildmode=longest,list,full
set wildmenu

augroup CursorLineOnlyInActiveWindow
  autocmd!
  autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  autocmd WinLeave * setlocal nocursorline
augroup END

