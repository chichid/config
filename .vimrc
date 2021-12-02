""""""""""""
" Core
""""""""""""""
call plug#begin()
  Plug 'ayu-theme/ayu-vim'
  Plug 'ciaranm/detectindent'
  Plug 'townk/vim-autoclose'
  Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle'  } 
  Plug 'leafgarland/typescript-vim'
  Plug 'neoclide/coc.nvim', {'branch': 'release', 'on': 'CocRestart'}
  Plug 'mxw/vim-jsx'
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
set ttymouse=sgr
set mouse=a
set splitright
set noswapfile
set cursorline
set autoread
au CursorHold * checktime  
let &winwidth = &columns * 7 / 10

""""""""""""""
" Indent
"""""""""""""""
set cindent
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set autoindent
set matchtime=0

""""""""""""""""""""
" Keyboard Mapping
""""""""""""""""""""
noremap <silent> <CR> :nohlsearch<CR>
noremap <C-K> :w<CR>:!clear;<UP><CR>

noremap > >>
noremap > >gv
noremap < <gv

" noremap <silent> <expr> <C-p> exists("g:NERDTree") && g:NERDTree.IsOpen() ? ":NERDTreeClose<CR>:FZF --reverse<CR>" : ":FZF --reverse<CR>"
noremap <silent> <expr> <C-b> exists("g:NERDTree") && g:NERDTree.IsOpen() ? ":NERDTreeClose<CR>" : ":NERDTreeToggle<CR><c-w><c-p>:NERDTreeFind<CR>"

vnoremap Y "+y
noremap <C-p> "+p

" WSL yank support
let s:clip = '/mnt/c/Windows/System32/clip.exe'  " change this path according to your mount point
if executable(s:clip)
    augroup WSLYank
        autocmd!
        autocmd TextYankPost * if v:event.operator ==# 'y' | call system(s:clip, @0) | endif
    augroup END
endif

"""""""""""""""""""""
" COC.vim 
"""""""""""""""""""""
set updatetime=300

if has("patch-8.1.1564")
  set signcolumn=number
else
  set signcolumn=yes
endif

" GoTo code navigation.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use enter to accept completion
if exists('*complete_info')
	inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
	inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <C-j> pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr> <C-K> pumvisible() ? "\<C-p>" : "\<Up>"
nnoremap <C-]> :call CocActionAsync('jumpDefinition')<CR>
inoremap <silent><expr> <c-space> coc#refresh()
nmap <F2> <Plug>(coc-rename)

""""""""""""""""""""""
" Easy Escape
""""""""""""""""""""""
let g:easyescape_chars = { "j": 1, "k": 1 }
let g:easyescape_timeout = 100 
set timeoutlen=10 ttimeoutlen=0
cnoremap jk <ESC>
cnoremap kj <ESC>

""""""""""""""
" Theme
""""""""""""""
augroup THEME
  autocmd VimEnter * syntax on
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
  autocmd VimEnter * hi LineNr ctermfg=darkgrey 
augroup END

"""""""""""""""""""""""
" FZF
"""""""""""""""""""""""
let g:fzf_layout = { 'left': '~40%' }
let g:fzf_buffers_jump = 1
let $FZF_DEFAULT_COMMAND = 'fzf --type f'
set runtimepath^=~/.vim/bundle/ctrlp.vim

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
" vim -b : edit binary using xxd-format!
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
