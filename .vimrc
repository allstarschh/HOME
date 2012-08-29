set backspace=indent,eol,start	" more powerful backspacing
ab  #s /************************************
ab  #e <space>***********************************/
set cindent
set hls
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set number
set nowrap
set incsearch
set formatoptions+=r
au FileType make set noexpandtab
au FileType python set noexpandtab  
colorscheme koehler
runtime ftplugin/man.vim
au BufNewFile,BufRead /home/allstars/test/proj2/*        setl ts=8 sts=8 sw=8 
au BufNewFile,BufRead *.jsm 	setf javascript
set exrc
