if (has("win16") || has("win95") || has("win32") || has("win64"))
    let g:isunix=0
else
    let g:isunix=1
endif
set nocompatible

"{{{個人信息
let g:author = 'renyuneyun'
let g:email  = 'renyuneyun@gmail.com'
"}}}

"Vundle配置{{{
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim' "Vundle itself
Plugin 'taglist.vim' "TagList
Plugin 'scrooloose/nerdtree' "file browser
Plugin 'fcitx.vim'
Plugin 'fholgado/minibufexpl.vim' "mini Buffer Explorer
Plugin 'Raimondi/delimitMate'
Plugin 'Lokaltog/vim-powerline' "高級vim狀態欄
"Plugin 'xolox/vim-misc'
"Plugin 'xolox/vim-session'

Plugin 'scrooloose/syntastic' "代碼分析

let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/.ycm_extra_conf.py'
Plugin 'Valloric/YouCompleteMe' "代碼補全
Plugin 'davidhalter/jedi' "Python用代碼補全（YCM調用）
Plugin 'asins/vimcdoc' "vim中文幫助文檔

"舊{{{0
"Plugin acp
"Plugin c
"Plugin ctags
"Plugin echofunc
"0}}}

call vundle#end()
filetype plugin indent on
"}}}Vundle配置結束

"外觀設置（字體，主體）{{{
set guifont=Monaco\ 13
colorscheme evening
"}}}外觀設置完

"編碼，換行設置{{{
set encoding=utf-8 "vim內部編碼
set fileencodings=utf-8,gb18030,big5 "讀取文件編碼嘗試
set fileencoding=utf-8 "保存文件編碼
set termencoding=utf-8
set fileformats=unix
"}}}完

"顯示設置{{{
set cursorline
"set cursorcolumn
set tabstop=4
set softtabstop=4
set shiftwidth=4
set listchars=tab:>-,trail:-
set list
set nu
"}}}顯示設置完


"set autoindent
"set cindent

"CTags & CScope{{{0
autocmd BufEnter * lcd %:p:h
map <F10> :call Do_CsTag()<CR>
nmap <C-@>s :cs find s <C-R>=expand("<cword>")<CR><CR>:copen<CR>
nmap <C-@>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-@>c :cs find c <C-R>=expand("<cword>")<CR><CR>:copen<CR>
nmap <C-@>t :cs find t <C-R>=expand("<cword>")<CR><CR>:copen<CR>
nmap <C-@>e :cs find e <C-R>=expand("<cword>")<CR><CR>:copen<CR>
nmap <C-@>f :cs find f <C-R>=expand("<cfile>")<CR><CR>:copen<CR>
nmap <C-@>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>:copen<CR>
nmap <C-@>d :cs find d <C-R>=expand("<cword>")<CR><CR>:copen<CR>
function Do_CsTag()
    let dir = getcwd()
    if filereadable("tags")
        if (g:isunix == 1)
            let tagsdeleted = delete("./"."tags")
        else
            let tagsdeleted = delete(dir."\\"."tags")
        endif
        if (tagsdeleted != 0)
            echohl WarningMsg | echo "Fail to do tags! Cannot delete the tags" | echohl None
            return
        endif
    endif
    if has("cscope")
        silent! execute "cs kill -1"
    endif
    if filereadable("cscope.files")
        if (g:isunix == 1)
            let csfilesdeleted = delete("./"."cscope.files")
        else
            let csfilesdeleted = delete(dir."\\"."cscope.files")
        endif
        if (csfilesdeleted != 0)
            echohl WarningMsg | echo "Fail to do cscope! Cannot delete the cscope.files" | echohl None
            return
        endif
    endif
    if filereadable("cscope.out")
        if (g:isunix == 1)
            let csoutdeleted = delete("./"."cscope.out")
        else
            let csoutdeleted = delete(dir."\\"."cscope.out")
        endif
        if (csoutdeleted != 0)
            echohl WarningMsg | echo "Fail to do cscope! Cannot delete the cscope.out" | echohl None
            return
        endif
    endif
    if (executable('ctags'))
        "silent! execute "!ctags -R --c-types=+p --fields=+S *"
        silent! execute "!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q ."
    endif
    if (executable('cscope') && has('cscope'))
        if (g:isunix == 1)
            silent! execute "!find . -name '*.h' -o -name '*.c' -o -name '*.cpp' -o -name '*.java' -o -name '*.cs' > cscope.files"
        else
            silent! execute "!dir /s/b *.c,*.cpp,*.h,*.java,*.cs >> cscope.files"
        endif
        silent! execute "!cscope -b"
        execute "normal :"
        if filereadable("cscope.out")
            execute "cs add cscope.out"
        endif
    endif
endfunction
"0}}}

"插件配置{{{
"powerline{{{1
set laststatus=2
let g:Powerline_symbols='unicode'
"1}}}
"minibufexpl{{{2
"用CTRL-TAB遍歷buffer
noremap <C-TAB>   :MBEbn<CR>
noremap <C-S-TAB> :MBEbp<CR>
"2}}}
"}}}


"自lilydjwg{{{
function! CleverTab()
	if strpart( getline('.'), 0, col('.')-1 ) =~ '^\s*$'
		return "\<Tab>"
	else
		return "\<C-P>"
	endif
endfunction
inoremap <Tab> <C-R>=CleverTab()<CR>
"}}}

"FileType設定{{{0
"代碼風格{{{1
syntax enable
filetype plugin indent on
"1}}}
"Python{{{2
":autocmd FileType python : set foldmethod=syntax
":autocmd FileType python :set smartindent 
":autocmd FileType python :set noexpandtab tabstop=4 softtabstop=4 shiftwidth=4
"2}}}
"0}}}

"自動添加作者信息等代碼註釋{{{0
"自linuxzen.com{{{1
"Python 注释
function! InsertPythonComment()
	exe 'normal'.1.'G'
	let line = getline('.')
	if line =~ '^#!.*$' || line =~ '^#.*coding:.*$'
		return
	endif
	normal O
	call setline('.', '#!/usr/bin/env python3')
	normal o
	call setline('.', '# -*- coding:utf-8 -*-')
	normal o
	call setline('.', '#')
	normal o
	call setline('.', '#   Author  :   '.g:author)
	normal o
	call setline('.', '#   E-mail  :   '.g:email)
	normal o
	call setline('.', '#   Date    :   '.strftime("%y/%m/%d %H:%M:%S"))
	normal o
	call setline('.', '#   Desc    :   ')
	normal o
	call setline('.', '#')
	normal o
	call cursor(7, 17)
endfunction
function! InsertPythonCommentWhenOpen()
	if a:lastline == 1 && !getline('.')
		call InsertPythonComment()
	end
endfunc
au FileType python :%call InsertPythonCommentWhenOpen()
au FileType python map <F4> :call InsertPythonComment()<cr>
"1}}}
"自修改{{{2
"clang{{{3
function! InsertCodeComment()
	exe 'normal'.1.'G'
	let line = getline('.')
	if line =~ '^#!.*$' || line =~ '^#.*coding:.*$'
		return
	endif
	normal O
	call setline('.', '/*   coding:utf-8')
	normal o
	call setline('.', ' *')
	normal o
	call setline('.', ' *   Author  :   '.g:author)
	normal o
	call setline('.', ' *   E-mail  :   '.g:email)
	normal o
	call setline('.', ' *   Date    :   '.strftime("%y/%m/%d %H:%M:%S"))
	normal o
	call setline('.', ' *   Desc    :   ')
	normal o
	call setline('.', ' *')
	normal o
	call setline('.', ' */')
	normal o
	call cursor(6, 17)
endfunction
function! InsertCodeCommentWhenOpen()
	if a:lastline == 1 && !getline('.')
		call InsertCodeComment()
	end
endfunc
au FileType java,cs :%call InsertCodeCommentWhenOpen()
au FileType c,cpp,java,cs map <F4> :call InsertCodeComment()<cr>
"3}}}
"Java{{{4
function! InsertJavaMainFunction()
"	exe 'normal'.1.'G'
"	let line = getline('.')
"	while line =~ '^/\*+.*$' || line =~ '^\*+/.*$'
"		normal j
"		let line = getline('.')
"	endwhile
"	查找註釋段。不可用
	normal Go
	call setline('.', 'public class '.expand("%:t:r").' {') "不含路徑和擴展名
	normal o
	call setline('.', '	public static void main(String[] args) {')
	normal o
	call setline('.', '	}')
	normal o
	call setline('.', '}')
	"normal o
	normal 3k$
endfunc
au FileType java : map <F5> :call InsertJavaMainFunction()<cr>
"4}}}
"2}}}
"0}}}
