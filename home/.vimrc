if (has("win16") || has("win95") || has("win32") || has("win64"))
	let g:isunix=0
else
	let g:isunix=1
endif
set nocompatible

"{{{個人信息
let g:author = 'renyuneyun'
let g:email  = 'renyuneyun@gmail.com'
let g:license= 'Apache 2.0 (See LICENSE)'
"}}}

"Vundle配置{{{
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim' "Vundle itself
if executable("ctags")
	"Plugin 'taglist.vim' "TagList
	Plugin 'majutsushi/tagbar'
	Plugin 'TagHighlight'
	"Plugin 'bandit.vim'
endif
Plugin 'scrooloose/nerdtree' "file browser
Plugin 'fholgado/minibufexpl.vim' "mini Buffer Explorer
Plugin 'Raimondi/delimitMate' "括號等自動補全
au FileType html let b:delimitMate_matchpairs = "(:),[:],{:}"
Plugin 'tpope/vim-surround' "編輯環繞符號
Plugin 'tpope/vim-commentary' "註釋代碼
"Rainbow Parentheses
Plugin 'luochen1990/rainbow'
let g:rainbow_active = 1
let g:rainbow_conf = {
			\   'guifgs': ['white', 'royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
			\   'ctermfgs': ['white', 'blue', 'yellow', 'cyan', 'magenta', 'red', 'lightblue', 'lightyellow', 'lightcyan', 'lightmagenta'],
			\   'operators': '_,_',
			\   'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
			\   'separately': {
			\       '*': {},
			\       'tex': {
			\           'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'],
			\       },
			\       'lisp': {
			\           'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick', 'darkorchid3'],
			\       },
			\       'vim': {
			\           'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/ fold', 'start=/(/ end=/)/ containedin=vimFuncBody', 'start=/\[/ end=/\]/ containedin=vimFuncBody', 'start=/{/ end=/}/ fold containedin=vimFuncBody'],
			\       },
			\       'html': {
			\           'parentheses': ['start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'],
			\       },
			\       'css': 0,
			\   }
			\}
Plugin 'jaxbot/semantic-highlight.vim'
Plugin 'bling/vim-airline' "高級vim狀態欄（可和許多插件集成）
"Plugin 'xolox/vim-misc'
"Plugin 'xolox/vim-session'

"let g:syntastic_python_checkers=['pylint']
"let g:syntastic_ignore_files=[".*\.py$"] "相傳syntastic檢查py時會卡噸，而已有pylint檢查
let g:syntastic_error_symbol = '>>'
let g:syntastic_warning_symbol = '>'
Plugin 'scrooloose/syntastic' "代碼分析
if v:version >= 703
	Plugin 'Yggdroot/indentLine' "縮進對齊豎線
endif
if has('signs')
	Plugin 'airblade/vim-gitgutter' "顯示git diff中的增改情況
endif
if (v:version > 703 || v:version == 703 && has("patch584")) && executable("cmake") "YCM要求Vim 7.3.584+ & CMake
	let g:ycm_path_to_python_interpreter = '/usr/bin/python3'
	let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/.ycm_extra_conf.py'
	let g:ycm_seed_identifiers_with_syntax = 1
	let g:ycm_extra_conf_globlist = ['~/coding/*']
	Plugin 'Valloric/YouCompleteMe' "代碼補全
else "不使用YCM的代碼補全
	Plugin 'davidhalter/jedi' "Python用代碼補全（由jedi-vim調用）
	Plugin 'davidhalter/jedi-vim' "Python代碼補全（無YCM）
	let g:jedi#force_py_version = 3
endif
if executable("go")
	Plugin 'fatih/vim-go'
	if executable("gotags")
		let g:tagbar_type_go = {
					\ 'ctagstype' : 'go',
					\ 'kinds'     : [
					\ 'p:package',
					\ 'i:imports:1',
					\ 'c:constants',
					\ 'v:variables',
					\ 't:types',
					\ 'n:interfaces',
					\ 'w:fields',
					\ 'e:embedded',
					\ 'm:methods',
					\ 'r:constructor',
					\ 'f:functions'
					\ ],
					\ 'sro' : '.',
					\ 'kind2scope' : {
					\ 't' : 'ctype',
					\ 'n' : 'ntype'
					\ },
					\ 'scope2kind' : {
					\ 'ctype' : 't',
					\ 'ntype' : 'n'
					\ },
					\ 'ctagsbin'  : 'gotags',
					\ 'ctagsargs' : '-sort -silent'
					\ }
	endif
endif
Plugin 'othree/xml.vim' "XML
Plugin 'html5.vim' "HTML5 + inline SVG
Plugin 'ap/vim-css-color' "CSS color shower
Plugin 'StanAngeloff/php.vim'
Plugin 'pangloss/vim-javascript'

Plugin 'asins/vimcdoc' "vim中文幫助文檔
if executable("fcitx")
	Plugin 'fcitx.vim'
endif

Plugin 'niklasl/vim-rdf' "RDF

call vundle#end()
filetype plugin indent on
"}}}Vundle配置結束

"外觀設置（字體，主體）{{{
set guifont=Monaco\ 16,DejaVu\ Sans\ Mono\ 16
colorscheme evening
"}}}外觀設置完

"編碼，換行設置{{{
set encoding=utf-8 "vim內部編碼
set fileencodings=utf-8,gb18030,big5 "讀取文件編碼嘗試
set fileencoding=utf-8 "保存文件編碼
set termencoding=utf-8
set fileformats=unix
"}}}完

"跳轉到上次位置{{{
if has("autocmd")
 au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif
"}}}

"顯示設置{{{
set colorcolumn=80 "80列豎線
set cursorline "高亮當前行
set cursorcolumn "高亮當前列
set tabstop=4
set softtabstop=4
set shiftwidth=4
set listchars=tab:>-,trail:-
set list "顯示空白
set nu "行號
set foldlevelstart=2
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
set laststatus=2 "始終顯示狀態行，以顯示vim-airline
set ttimeoutlen=100 "降低按鍵等待時間，以加快fcitx.vim響應
	"minibufexpl{{{
"用CTRL-TAB遍歷buffer
noremap <C-TAB>   :MBEbn<CR>
noremap <C-S-TAB> :MBEbp<CR>
	"}}}
	"YouCompleteMe {{{
map <F5> :YcmCompleter GoTo<cr>
map <F6> :YcmCompleter GoToDefinition<cr>
map <F7> :YcmCompleter GoToDeclaration<cr>
map <F8> :YcmCompleter GetParent<cr>
	"}}}
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
:autocmd FileType python : set foldmethod=indent
":autocmd FileType python :set smartindent 
:autocmd FileType python :set expandtab tabstop=4 softtabstop=4 shiftwidth=4
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
	call setline('.', '#   License :   '.g:license)
	normal o
	call setline('.', '#')
	normal o
	normal o
	call setline('.', "'''")
	normal o
	normal o
	call setline('.', "'''")
	call cursor(11, 0)
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
	call setline('.', ' *   License :   '.g:license)
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
"2}}}
"0}}}

" 修改變量名 自http://stackoverflow.com/questions/597687/changing-variable-names-in-vim {{{
" For local replace
nnoremap gr gd[{V%::s/<C-R>///gc<left><left><left>

" For global replace
nnoremap gR gD:%s/<C-R>///gc<left><left><left>
" }}}

" Golang {{{
au FileType go map <F9> :GoBuild<cr>
au FileType go map <S-F9> :GoRun<cr>
" }}}


au FileType c,cpp,java,cs,python,go :SemanticHighlight
