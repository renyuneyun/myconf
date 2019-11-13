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

"外部工具{{{
set cscopetag                  " 使用 cscope 作为 tags 命令
set cscopeprg='gtags-cscope'   " 使用 gtags-cscope 代替 cscope
"}}}

"1}}}

"功能定製{{{1

"CleverTab 自lilydjwg{{{
function! CleverTab()
	if strpart( getline('.'), 0, col('.')-1 ) =~ '^\s*$'
		return "\<Tab>"
	else
		return "\<C-n>"
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
function! HasPlugin(name)
	return has_key(g:plugs, a:name)
endfunction
"1}}}

"插件{{{1
filetype off
" Load vim-plug
if empty(glob("~/.vim/autoload/plug.vim"))
	execute '!curl --create-dirs -fLo ~/.vim/autoload/plug.vim https://raw.github.com/junegunn/vim-plug/master/plug.vim'
endif
call plug#begin()

"Vim表現{{{
Plug 'thaerkh/vim-workspace' "Workspace
Plug 'mhinz/vim-startify' "起始頁面

"Plug 'xolox/vim-misc'
"Plug 'xolox/vim-session'
Plug 'asins/vimcdoc' "vim中文幫助文檔

if executable("fcitx") "fcitx自動切換{{{
	Plug 'lilydjwg/fcitx.vim'
	"Plug 'vim-scripts/fcitx.vim'
endif "}}}

Plug 'ryanoasis/vim-devicons' "爲許多插件增加文件類型圖標

Plug 'bling/vim-airline' "高級vim狀態欄（可和許多插件集成）

Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' } "file browser

if executable("ctags")
	"Plug 'taglist.vim' "TagList
	Plug 'majutsushi/tagbar'
endif

Plug 'tweekmonster/startuptime.vim', { 'on': 'StartupTime' } "Profiling vim plugins
"}}}

"編程·UI{{{
if has('signs')
	Plug 'airblade/vim-gitgutter' "顯示git diff中的增改情況
endif
if v:version >= 703
	Plug 'Yggdroot/indentLine' "縮進對齊豎線
endif
Plug 'ap/vim-css-color' "CSS顏色顯示
Plug 'luochen1990/rainbow' "Rainbow Parentheses
Plug 'jaxbot/semantic-highlight.vim', { 'on': 'SemanticHighlight' }
if executable("ctags") "TagHighlight
	"Plug 'vim-scripts/TagHighlight'
	Plug 'abudden/taghighlight-automirror'
	"Plug 'https://bitbucket.org/abudden/taghighlight' " in mercurial, can't be managed by vim-plug
	"Plug 'bandit.vim'
endif

if v:version > 704 || v:version == 704 && has("patch774")
	Plug 'Shougo/echodoc.vim' "在echo area顯示文檔（簽名）
endif
"}}}

"編程·通用功能{{{
Plug 'tpope/vim-surround' "編輯環繞符號
Plug 'tpope/vim-commentary' "註釋代碼
Plug 'jiangmiao/auto-pairs' "括號自動配對及更多舒適操作

Plug 'tpope/vim-sleuth' "自動探測縮進

Plug 'dhruvasagar/vim-table-mode'

Plug 'Chiel92/vim-autoformat'

"代碼片段{{{
if has("python") || has("python3") || has("python2")
	Plug 'SirVer/ultisnips'
	Plug 'honza/vim-snippets'
endif
"}}}
"}}}

"編程·語言特色插件{{{
Plug 'fatih/vim-go', { 'for': 'go', 'do': ':GoUpdateBinaries' } "Go
Plug 'plytophogy/vim-virtualenv', { 'for': 'python', 'on': ['VirtualEnvList', 'VirtualEnvActivate'] } "VirtuelEnv support for vim
Plug 'rust-lang/rust.vim', { 'for': 'rust' } "Rust
Plug 'othree/xml.vim' "XML
Plug 'vim-scripts/html5.vim' "HTML5 + inline SVG
Plug 'pangloss/vim-javascript' "JS
Plug 'StanAngeloff/php.vim' "PHP
Plug 'niklasl/vim-rdf', { 'for': 'rdf' } "RDF
Plug 'lervag/vimtex' "TeX
"}}}

"編程·自動補全與分析{{{

"自動補全框架及框架相關{{{1
if has('nvim') "deoplete爲neovim開發 TODO: 加入vim 8下的deoplete
	Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
	Plug 'Shougo/deoplete-clangx' "C-family languages
	Plug 'davidhalter/jedi', { 'for': 'python' } "Python
	Plug 'deoplete-plugins/deoplete-jedi', { 'for': 'python' } "依賴jedi
	if executable("go")
		Plug 'stamblerre/gocode', { 'for': 'go' } "Golang
		Plug 'deoplete-plugins/deoplete-go', { 'for': 'go', 'do': 'make'} "依賴gocode
	endif
elseif (v:version > 703 || v:version == 703 && has("patch584")) && executable("cmake") "YCM 要求Vim 7.3.584+ & CMake
	Plug 'Valloric/YouCompleteMe' "代碼補全
else "不使用框架的自動補全
	Plug 'davidhalter/jedi' "Python用代碼補全（由jedi-vim調用）
	Plug 'davidhalter/jedi-vim' "Python代碼補全（無YCM）
endif
"1}}}

"各框架下的自動補全{{{1
if executable('racer')
	Plug 'racer-rust/vim-racer', { 'for': 'rust' } "Racer (Rust Auto-CompletER)
endif
"1}}}

if executable("ctags")
	if has('nvim') || v:version > 800
		Plug 'ludovicchabant/vim-gutentags'
	endif
endif

if has('nvim') || v:version > 800
	Plug 'neomake/neomake' "異步的syntastic
else
	Plug 'scrooloose/syntastic' "代碼分析
endif
"}}}

call plug#end()
filetype plugin indent on
"1}}}

"通常插件配置{{{1
if HasPlugin("fcitx.vim") "{{{
	set ttimeoutlen=100 "降低按鍵等待時間，以加快fcitx.vim響應
endif "}}}

if HasPlugin("vim-airline") "{{{
	set laststatus=2 "始終顯示狀態行，以顯示vim-airline
	let g:airline#extensions#tabline#enabled = 1
	let g:airline#extensions#tabline#buffer_min_count = 2
	let g:airline#extensions#tabline#buffer_nr_show = 1
	"用CTRL-TAB遍歷buffer
	nnoremap <C-tab> :bn<CR>
	nnoremap <C-s-tab> :bp<CR>
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

if HasPlugin("ultisnips") "{{{
	let g:UltiSnipsEditSplit="vertical"
	let g:UltiSnipsExpandTrigger="<A-a>"
endif "}}}

if HasPlugin("vim-workspace") "{{{
	let g:workspace_session_directory = $HOME . '/.vim/sessions/'
	let g:workspace_autosave_ignore = ['gitcommit', '.gitignore']
	nnoremap <leader>s :ToggleWorkspace<CR>
endif "}}}

if HasPlugin("echodoc.vim") "{{{
	let g:echodoc#enable_at_startup = 1
	if HasPlugin("vim-airline")
		set noshowmode
	elseif has('nvim')
		let g:echodoc#type = 'virtual'
		"let g:echodoc#type = 'floating'
		"highlight link EchoDocFloat Pmenu
	else
		set cmdheight=2
	endif
endif "}}}

if HasPlugin("deoplete.nvim") "{{{
	let g:deoplete#enable_at_startup = 1
	let g:deoplete#sources#jedi#show_docstring = 1
endif "}}}

if HasPlugin("vim-racer") "{{{
	let g:racer_experimental_completer = 1
endif "}}}

if HasPlugin("YouCompleteMe") "{{{
	let g:ycm_path_to_python_interpreter = '/usr/bin/python3'
	let g:ycm_rust_src_path = '~/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src'
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

if HasPlugin("vim-gutentags") "{{{
	" 抄自 http://www.skywind.me/blog/archives/2084 和 https://zhuanlan.zhihu.com/p/36279445
	set tags=./.tags;,.tags "TODO: 這行是幹嘛的？？？沒見到使用這個變量
	" gutentags 搜索工程目录的标志，碰到这些文件/目录名就停止向上一级目录递归
	let g:gutentags_project_root = ['.root', '.svn', '.git', '.hg', '.project']
	" 所生成的数据文件的名称
	let g:gutentags_ctags_tagfile = '.tags'

	let g:gutentags_modules = []
	if executable('ctags')
		let g:gutentags_modules += ['ctags']
	endif
	if executable('gtags-cscope') && executable('gtags')
		let g:gutentags_modules += ['gtags_cscope']
	endif

	" 将自动生成的 tags 文件全部放入 ~/.cache/tags 目录中，避免污染工程目录
	let s:vim_tags = expand('~/.cache/tags')
	let g:gutentags_cache_dir = s:vim_tags
	" 配置 ctags 的参数
	let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
	let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
	let g:gutentags_ctags_extra_args += ['--c-kinds=+px']

	" 如果使用 universal ctags 需要增加下面一行
	let g:gutentags_ctags_extra_args += ['--output-format=e-ctags']

	" 禁用 gutentags 自动加载 gtags 数据库的行为
	"let g:gutentags_auto_add_gtags_cscope = 0
endif "}}}
"1}}}

"語言{{{1

"多語言{{{
au FileType c,cpp,java,cs,python,go,rust :SemanticHighlight
"}}}

let $GTAGSLABEL = 'native-pygments'
let $GTAGSCONF = '/usr/share/gtags/gtags.conf'

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

