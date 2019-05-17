""""""""""""
" Core
""""""""""""""
execute pathogen#infect()

"""""""""""
" General
""""""""""""
syntax on
set nocompatible
set backspace=indent,eol,start
set whichwrap+=<,>,h,l,[,]
set number              
set wrap!                
set encoding=utf-8     
set wildmenu
set showmatch
set ruler  
set incsearch
set hlsearch
set autoread          
set linebreak
set nolist 
set textwidth=0
set wrapmargin=0 
set history=1000 
set ignorecase
set smartcase
set laststatus=0

"""""""""""""""
" AutoComplete 
"""""""""""""""
let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabClosePreviewOnPopupClose = 1

"""""""""""""""
" Indent
"""""""""""""""
filetype plugin indent on
set tabstop=2
set expandtab
set shiftwidth=2
set autoindent
set smartindent
set matchtime=0

let delimitMate_expand_cr = 1
autocmd VimEnter * DetectIndent

""""""""""""""
" Keyboard Mapping
"""""""""""""""
nmap q :qa<CR>
nnoremap <silent> t gt
nnoremap <silent> T gT
nnoremap <BS> i<BS><ESC><ESC> 
noremap <silent> <CR> :nohlsearch<CR>
nnoremap \ i<CR><ESC>
nnoremap <BAR> o<ESC><UP>
nnoremap <S-RIGHT> $
nnoremap <S-LEFT> 0
nnoremap < <<
nnoremap > >>
vnoremap > >gv
vnoremap < <gv
noremap  <silent> ? :NERDTreeClose<CR>:FZF --reverse<CR>  
nnoremap <silent> <expr> / g:NERDTree.IsOpen() ? ":NERDTreeClose<CR>:FZF --reverse<CR>" : "/"
nnoremap <silent> <expr> <RIGHT> g:NERDTree.IsOpen() ? ":call MyNERDTreeOpenNode()<CR>" : "<RIGHT>"
nnoremap <silent> <expr> <LEFT> g:NERDTree.IsOpen() ? ":call MyNERDTreeCloseNode()<CR>" : "<LEFT>"
nnoremap <silent> <C-n> :NERDTreeToggle<CR>

""""""""""""""""""""""
" Escape
""""""""""""""""""""""
let g:easyescape_chars = { "j": 1, "k": 1 }
let g:easyescape_timeout = 100 
set timeoutlen=10 ttimeoutlen=0
cnoremap jk <ESC>
cnoremap kj <ESC>

""""""""""""""
" Theme
""""""""""""""
colorscheme default
set cursorline

highlight LineNr cterm=NONE ctermbg=0 ctermfg=241
highlight StatusLine ctermbg=0
highlight CursorLine cterm=NONE ctermbg=8 
highlight CursorLineNr cterm=bold ctermbg=8 ctermfg=7
highlight VertSplit ctermfg=0 ctermbg=0
highlight MatchParen term=NONE ctermbg=LightGrey ctermfg=0
highlight Visual term=NONE ctermbg=11 ctermfg=0
highlight EndOfBuffer ctermfg=0
highlight Search term=NONE cterm=NONE ctermfg=0
highlight NERDTreeClosable ctermfg=11 
highlight Directory ctermfg=231
highlight Pmenu ctermfg=7 ctermbg=0
highlight PmenuSbar ctermbg=8
highlight PmenuThumb ctermbg=7

highlight Statement ctermfg=11
highlight Identifier ctermfg=6
highlight String ctermfg=10
highlight Character ctermfg=10
highlight Number ctermfg=10 
highlight Boolean ctermfg=10 
highlight Float ctermfg=10

highlight StorageClass ctermfg=11
highlight Include ctermfg=11

"""""""""""""""""""""""
" FZF
"""""""""""""""""""""""
let g:fzf_layout = { 'left': '~40%' }
let $FZF_DEFAULT_COMMAND = 'fd --type f'

"""""""""""""
" NERDTree
""""""""""""""
let g:NERDTreeMinimalUI = 1
let g:NERDTreeDirArrowExpandable = '▹'
let g:NERDTreeQuitOnOpen = 1
let g:NERDTreeMapHelp = 'H'

autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | call MyNERDTreeOpenDir() | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

function! MyNERDTreeOpenDir()
	execute ":NERDTreeFocus"
	
	for child in g:NERDTreeFileNode.GetRootForTab().children
		if has_key(child, "path") && child.path.isDirectory !=# 1 && child.isVisible() ==# 1
			call child.putCursorHere(0, 0)
			break
		endif
	endfor
endfunction

function! MyNERDTreeOpenNode()
	let l:sf = g:NERDTreeFileNode.GetSelected()
	if has_key(l:sf, "path")
		if l:sf.path.isDirectory ==# 1 && l:sf.isOpen ==# 0 
			call l:sf.activate()
		elseif l:sf.path.isDirectory !=# 1 
			call l:sf.activate()
		endif
	endif
endfunction

function! MyNERDTreeCloseNode()
	let l:sf = g:NERDTreeFileNode.GetSelected()
	if has_key(l:sf, "path")
		if l:sf.path.isDirectory ==# 1 && l:sf.isOpen ==# 1
			call l:sf.activate()
		else
			call l:sf.parent.putCursorHere(0, 0)
		endif
	endif
endfunction


