set backspace=indent,eol,start	" more powerful backspacing
ab  #s /************************************
ab  #e <space>***********************************/
set smartindent
set hls
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set number
set nowrap
set incsearch
set formatoptions+=r
set cc=80
set list
au FileType make set noexpandtab
au BufNewFile,BufRead *.jsm    setf javascript
au BufNewFile,BufRead *.aidl   setf java
augroup filetypedetect
au BufNewFile,BufRead *.webidl setf widl
au BufNewFile,BufRead *.widl   setf widl
augroup END 
"au FileType python set noexpandtab  
colorscheme koehler
runtime ftplugin/man.vim
au BufNewFile,BufRead /home/allstars/test/proj2/*        setl ts=8 sts=8 sw=8 
set exrc
set modeline
match ErrorMsg '\s\+$'
