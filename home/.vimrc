if (has("win16") || has("win95") || has("win32") || has("win64"))
	let g:isunix=0
else
	let g:isunix=1
endif

"基本設置{{{1
set nocompatible

"外觀設置（字體，主體）{{{2
if has('nvim')
	set guifont=Fira\ Code:h16
else
	set guifont=Fira\ Code\ 16,Monaco\ 16,DejaVu\ Sans\ Mono\ 16
endif
colorscheme evening
"2}}}

"編碼，換行設置{{{2
set encoding=utf-8 "vim內部編碼
set fileencodings=utf-8,gb18030,big5 "讀取文件編碼嘗試
set fileencoding=utf-8 "保存文件編碼
set termencoding=utf-8
set fileformats=unix
"2}}}

"跳轉到上次位置{{{2
if has("autocmd")
 au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif
"2}}}

"顯示設置{{{2
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
"2}}}

"set autoindent
"set cindent

"FileType{{{
syntax enable
filetype plugin indent on
"}}}

"1}}}

"功能定製{{{1

"CleverTab 自lilydjwg{{{
function! CleverTab()
	if strpart( getline('.'), 0, col('.')-1 ) =~ '^\s*$'
		return "\<Tab>"
	else
		return "\<C-P>"
	endif
endfunction
inoremap <Tab> <C-R>=CleverTab()<CR>
"}}}

"修改變量名 自http://stackoverflow.com/questions/597687/changing-variable-names-in-vim {{{
"For local replace
nnoremap gr gd[{V%::s/<C-R>///gc<left><left><left>

"For global replace
nnoremap gR gD:%s/<C-R>///gc<left><left><left>
"}}}
"1}}}

"vimrc輔助函數{{{1
let s:plugin_dir = glob("~/.vim/plugged")
function! HasPlugin(name)
	let dir_name = s:plugin_dir . "/" . a:name
	return isdirectory(dir_name) && !empty(dir_name)
endfunction
"1}}}

"插件{{{1
filetype off
" Load vim-plug
if empty(glob("~/.vim/autoload/plug.vim"))
	execute '!curl --create-dirs -fLo ~/.vim/autoload/plug.vim https://raw.github.com/junegunn/vim-plug/master/plug.vim'
endif
call plug#begin()
if executable("ctags")
	if has('nvim') || v:version > 800
		Plug 'ludovicchabant/vim-gutentags'
	endif
	"Plug 'taglist.vim' "TagList
	Plug 'majutsushi/tagbar'
	Plug 'vim-scripts/TagHighlight'
	"Plug 'https://bitbucket.org/abudden/taghighlight' " in mercurial, can't be managed by vim-plug
	"Plug 'bandit.vim'
endif
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' } "file browser
Plug 'fholgado/minibufexpl.vim' "mini Buffer Explorer
Plug 'Raimondi/delimitMate' "括號等自動補全
Plug 'tpope/vim-surround' "編輯環繞符號
Plug 'tpope/vim-commentary' "註釋代碼
Plug 'luochen1990/rainbow' "Rainbow Parentheses
Plug 'jaxbot/semantic-highlight.vim', { 'on': 'SemanticHighlight' }
Plug 'bling/vim-airline' "高級vim狀態欄（可和許多插件集成）
"Plug 'xolox/vim-misc'
"Plug 'xolox/vim-session'

if v:version >= 703
	Plug 'Yggdroot/indentLine' "縮進對齊豎線
endif
if has('signs')
	Plug 'airblade/vim-gitgutter' "顯示git diff中的增改情況
endif
if (v:version > 703 || v:version == 703 && has("patch584")) && executable("cmake") "YCM要求Vim 7.3.584+ & CMake
	Plug 'Valloric/YouCompleteMe' "代碼補全
else "不使用YCM的代碼補全
	Plug 'davidhalter/jedi' "Python用代碼補全（由jedi-vim調用）
	Plug 'davidhalter/jedi-vim' "Python代碼補全（無YCM）
endif
if has('nvim') || v:version > 800
	Plug 'neomake/neomake' "異步的syntastic
else
	Plug 'scrooloose/syntastic' "代碼分析
endif
Plug 'fatih/vim-go', { 'for': 'go' }
Plug 'rust-lang/rust.vim' "Rust
Plug 'racer-rust/vim-racer' "Racer (Rust Auto-CompletER)
Plug 'othree/xml.vim' "XML
Plug 'vim-scripts/html5.vim' "HTML5 + inline SVG
Plug 'ap/vim-css-color' "CSS color shower
Plug 'StanAngeloff/php.vim'
Plug 'pangloss/vim-javascript'

Plug 'asins/vimcdoc' "vim中文幫助文檔
if executable("fcitx")
	Plug 'lilydjwg/fcitx.vim'
	"Plug 'vim-scripts/fcitx.vim'
endif

Plug 'niklasl/vim-rdf', { 'for': 'rdf' } "RDF

Plug 'tweekmonster/startuptime.vim', { 'on': 'StartupTime' } "Profiling vim plugins

"UltiSnips{{{
if has("python") || has("python3") || has("python2")
	Plug 'SirVer/ultisnips'
	Plug 'honza/vim-snippets'
endif
"}}}

Plug 'lervag/vimtex' "TeX

call plug#end()
filetype plugin indent on
"1}}}

"通常插件配置{{{1
if HasPlugin("vim-airline") "{{{
	set laststatus=2 "始終顯示狀態行，以顯示vim-airline
endif "}}}

if HasPlugin("fcitx.vim") "{{{
	set ttimeoutlen=100 "降低按鍵等待時間，以加快fcitx.vim響應
endif "}}}

if HasPlugin("minibufexpl.vim") "{{{
	"用CTRL-TAB遍歷buffer
	noremap <C-TAB>   :MBEbn<CR>
	noremap <C-S-TAB> :MBEbp<CR>
endif "}}}

if HasPlugin("YouCompleteMe") "{{{
	let g:ycm_path_to_python_interpreter = '/usr/bin/python3'
	let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'
	let g:ycm_seed_identifiers_with_syntax = 1
	let g:ycm_extra_conf_globlist = ['~/coding/*']

	map <F5> :YcmCompleter GoTo<cr>
	map <F6> :YcmCompleter GoToDefinition<cr>
	map <F7> :YcmCompleter GoToDeclaration<cr>
	map <F8> :YcmCompleter GoToReferences<cr>
endif "}}}

if HasPlugin("jedi") "{{{
	let g:jedi#force_py_version = 3
endif "}}}

if HasPlugin("syntastic") "{{{
	"let g:syntastic_python_checkers=['pylint']
	"let g:syntastic_ignore_files=[".*\.py$"] "相傳syntastic檢查py時會卡噸，而已有pylint檢查
	let g:syntastic_error_symbol = '>>'
	let g:syntastic_warning_symbol = '>'
endif "}}}

if HasPlugin("ultisnips") "{{{
	let g:UltiSnipsEditSplit="vertical"
	let g:UltiSnipsExpandTrigger="<A-a>"
endif "}}}

if HasPlugin("rainbow") "{{{
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
endif "}}}

if HasPlugin("vim-gutentags") "{{{
	" 抄自 http://www.skywind.me/blog/archives/2084
	set tags=./.tags;,.tags
	" gutentags 搜索工程目录的标志，碰到这些文件/目录名就停止向上一级目录递归
	let g:gutentags_project_root = ['.root', '.svn', '.git', '.hg', '.project']
	" 所生成的数据文件的名称
	let g:gutentags_ctags_tagfile = '.tags'
	" 将自动生成的 tags 文件全部放入 ~/.cache/tags 目录中，避免污染工程目录
	let s:vim_tags = expand('~/.cache/tags')
	let g:gutentags_cache_dir = s:vim_tags
	" 配置 ctags 的参数
	let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
	let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
	let g:gutentags_ctags_extra_args += ['--c-kinds=+px']
endif "}}}

"1}}}

"語言{{{1

"多語言{{{
au FileType c,cpp,java,cs,python,go,rust :SemanticHighlight
"}}}

"Python{{{
:autocmd FileType python : set foldmethod=indent
":autocmd FileType python :set smartindent 
:autocmd FileType python :set expandtab tabstop=4 softtabstop=4 shiftwidth=4
"}}}

"vim{{{
au FileType vim setlocal foldmethod=marker
au FileType vim setlocal foldlevel=0
"}}}

"HTML{{{
if HasPlugin("delimitMate") "{{{
	au FileType html let b:delimitMate_matchpairs = "(:),[:],{:}"
endif "}}}
"}}}

"Golang{{{
au FileType go map <F9> :GoBuild<cr>
au FileType go map <S-F9> :GoRun<cr>

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
"}}}
"1}}}

"CTags & CScope{{{1
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
function! Do_CsTag()
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
"1}}}


"自動添加作者信息等代碼註釋{{{1
"個人信息{{{2
let g:author = 'renyuneyun'
let g:email  = 'renyuneyun@gmail.com'
let g:license= 'Apache 2.0 (See LICENSE)'
"2}}}

"自linuxzen.com{{{2
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
"2}}}
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
"1}}}

