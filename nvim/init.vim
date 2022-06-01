""""""""""""
" Plugins 
""""""""""""""
call plug#begin()
  Plug 'ayu-theme/ayu-vim'
  Plug 'townk/vim-autoclose'
  Plug 'ctrlpvim/ctrlp.vim', {'on': 'CtrlP'}
  Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle'  } 
  Plug 'mxw/vim-jsx', { 'for': ['tsx', 'jsx'] }
  Plug 'leafgarland/typescript-vim', { 'for': ['tsx', 'ts'] }
  Plug 'nvim-treesitter/nvim-treesitter'
  Plug 'williamboman/nvim-lsp-installer'
  Plug 'neovim/nvim-lspconfig'
call plug#end()

"""""""""""
" General
""""""""""""
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
set linebreak
set nolist 
set history=10000
set textwidth=0
set wrapmargin=0 
set ignorecase
set smartcase
set laststatus=0
set mouse=a
set splitright
set noswapfile
set cursorline
set autoread
set foldmethod=indent
set foldlevel=10
set cindent
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set autoindent
set matchtime=0
au CursorHold * checktime  
let &winwidth = &columns * 7 / 10

""""""""""""""""""""
" Keyboard Mapping
""""""""""""""""""""
noremap > >>
noremap > >gv
noremap <silent> <CR> :nohlsearch<CR>
noremap <silent> <expr> <C-b> exists("g:NERDTree") && g:NERDTree.IsOpen() ? ":NERDTreeClose<CR>" : ":NERDTreeToggle<CR><c-w><c-p>:NERDTreeFind<CR>"

"""""""""""""""""""""
" Custom Commands 
"""""""""""""""""""""
command ConfigReload :source $MYVIMRC
command Config :e $MYVIMRC
command -nargs=1 ConfigModule execute ":e ".substitute($MYVIMRC, "init.vim", "lua/", "").<f-args>.".lua"
command -nargs=+ Runner :!<args>
noremap <C-K> :w<CR>:Runner <UP><CR>

""""""""""""""""""""""
" Ctrlp 
""""""""""""""""""""""
let g:ctrlp_match_window = 'top,order:btt,min:1,max:10,results:10'
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -c --exclude-standard --recurse-submodules | grep -x -v "$( git ls-files -d --exclude-standard )" ; git ls-files -o --exclude-standard', 'find %s -type f' ]
let g:ctrlp_prompt_mappings = { 'AcceptSelection("e")': ['<2-LeftMouse>'], 'AcceptSelection("t")': ['<cr>'], }

"""""""""""""
" Treesitter 
""""""""""""""
lua require('treesitter')

"""""""""""""
" NERDTree
""""""""""""""
let g:NERDTreeMinimalUI = 1
let g:NERDTreeDirArrowExpandable = ''
let g:NERDTreeQuitOnOpen = 1
let g:NERDTreeMapHelp = 'H'

"""""""""""""
" Hex Editor
""""""""""""""
augroup Binary
  au!
  au BufReadPre  *.bin let &bin=1
  au BufReadPost *.bin if &bin | %!xxd
  au BufReadPost *.bin set ft=xxd | endif
  au BufWritePre *.bin if &bin | %!xxd -r
  au BufWritePre *.bin endif
  au BufWritePost *.bin if &bin | %!xxd
  au BufWritePost *.bin set nomod | endif
augroup END

""""""""""""""
" Theme
""""""""""""""
augroup THEME
  autocmd VimEnter * syntax on
  autocmd VimEnter * filetype plugin indent on
  autocmd VimEnter * set termguicolors     
  autocmd VimEnter * let ayucolor="dark" 
  autocmd VimEnter * colorscheme ayu
  autocmd VimEnter * hi Normal guibg=black
  autocmd VimEnter * hi EndOfBuffer ctermfg=black guifg=black
  autocmd VimEnter * hi SignColumn guibg=NONE ctermbg=NONE
  autocmd VimEnter * hi TabLine ctermbg=grey ctermfg=black guibg=#1f2430
  autocmd VimEnter * hi TabLineSel ctermbg=black ctermfg=white guibg=white guifg=black
  autocmd VimEnter * hi TabLineFill ctermfg=black guifg=black
  autocmd VimEnter * hi Visual cterm=none ctermbg=darkgrey ctermfg=white
  autocmd VimEnter * hi Search cterm=none ctermbg=darkgrey ctermfg=white
  autocmd VimEnter * hi MatchParen ctermfg=white ctermbg=darkgrey
  autocmd VimEnter * hi CursorLineNr term=bold ctermfg=white
  autocmd VimEnter * hi LineNr ctermfg=yellow
augroup END

""""""""""""""""""
" WSL yank support
""""""""""""""""""
let s:clip = '/mnt/c/Windows/System32/clip.exe'  " change this path according to your mount point
if executable(s:clip)
    augroup WSLYank
        autocmd!
        autocmd TextYankPost * if v:event.operator ==# 'y' | call system(s:clip, @0) | endif
    augroup END
endif

