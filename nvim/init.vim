""""""""""""
" Plugins 
""""""""""""""
call plug#begin()
  Plug 'ayu-theme/ayu-vim'
  Plug 'townk/vim-autoclose'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle'  } 
  Plug 'mxw/vim-jsx', { 'for': ['tsx', 'jsx'] }
  Plug 'leafgarland/typescript-vim', { 'for': ['tsx', 'ts'] }
  Plug 'nvim-treesitter/nvim-treesitter'
  Plug 'neoclide/coc.nvim', {'branch': 'release', 'on': 'CocEnable'}
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
noremap <silent> <CR> :nohlsearch<CR>
noremap <silent> <ESC> :nohlsearch<ESC>
noremap <silent> <C-l> :b#<CR>
noremap <silent> <C-K> :w<CR>:RunExternal <UP><CR>
noremap <silent> <expr> <C-b> exists("g:NERDTree") && g:NERDTree.IsOpen() ? ":NERDTreeClose<CR>" : ":NERDTreeToggle<CR><c-w><c-p>:NERDTreeFind<CR>"

"""""""""""""""""""""
" Custom Commands 
"""""""""""""""""""""
command ReloadConfig :source $MYVIMRC
command Config :e $MYVIMRC
command -nargs=1 ConfigModule execute ":e ".substitute($MYVIMRC, "init.vim", "lua/", "").<f-args>.".lua"
command -nargs=? RunExternal call RunInFloatingWindow(<q-args>)

""""""""""""""""""""""
" Ctrlp 
""""""""""""""""""""""
let g:ctrlp_match_window = 'top,order:btt,min:1,max:10,results:10'
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -c --exclude-standard --recurse-submodules | grep -x -v "$( git ls-files -d --exclude-standard )" ; git ls-files -o --exclude-standard', 'find %s -type f' ]
let g:ctrlp_prompt_mappings = { 'AcceptSelection("e")': ['<2-LeftMouse>'], 'AcceptSelection("t")': ['<cr>'], }

"""""""""""""
" Treesitter 
""""""""""""""
lua << EOF
require'nvim-treesitter.configs'.setup {
  indent = {
    enable = true,
  },
  highlight = {
    enable = false,
  }
}
EOF

"""""""""""""
" Telescope 
""""""""""""""
noremap <silent> <C-p> :Telescope find_files<CR>

lua << EOF
local actions = require("telescope.actions")

require('telescope').setup {
  pickers = {
    find_files = {
      theme = 'dropdown',
      prompt_title = '',
      previewer = false,
      layout_config = {
        width = 0.7,
        height = 0.95 
      },
    }
  },
  defaults = {
    mappings = {
      i = {
        ["<esc>"] = actions.close,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-j>"] = actions.move_selection_next,
      },
    },
  },
}

EOF

"""""""""""""
" COC
""""""""""""""
set encoding=utf-8
set hidden
set nobackup
set nowritebackup
set cmdheight=1
set shortmess+=c

inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : CheckBackspace() ? "\<TAB>" : coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <silent><expr> <TAB> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nnoremap <silent> K :call ShowDocumentation()<CR>

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

if has("nvim-0.5.0") || has("patch-8.1.1564")
  set signcolumn=number
else
  set signcolumn=yes
endif

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

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
  autocmd VimEnter * hi FloatBorder ctermfg=white
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

""""""""""""""""""""
" Floating Terminal 
""""""""""""""""""""
function! RunInFloatingWindow(command) abort
  let width = min([&columns - 4, max([80, &columns - 20])])
  let height = min([&lines - 4, max([20, &lines - 10])])
  let top = ((&lines - height) / 2) - 1
  let left = (&columns - width) / 2
  let opts = {'relative': 'editor', 'row': top, 'col': left, 'width': width, 'height': height, 'style': 'minimal'}

  let top = "╭" . repeat("─", width - 2) . "╮"
  let mid = "│" . repeat(" ", width - 2) . "│"
  let bot = "╰" . repeat("─", width - 2) . "╯"
  let lines = [top] + repeat([mid], height - 2) + [bot]
  let s:buf = nvim_create_buf(v:false, v:true)
  call nvim_buf_set_lines(s:buf, 0, -1, v:true, lines)

  set winhl=Normal:Floating
  let s:text_buf = nvim_create_buf(v:false, v:true)
  let opts.row += 1
  let opts.height -= 2
  let opts.col += 2
  let opts.width -= 4
  let opts.style = 'minimal' 
  let opts.border = 'rounded'

  call nvim_open_win(s:text_buf, v:true, opts)
  call nvim_set_current_buf(s:text_buf)
  execute "term " . a:command

  map <buffer> j <C-e>
  map <buffer> k <C-y>
  map <buffer> <silent> <ESC> :close<CR>
  map <buffer> <silent> <CR> :close<CR>
endfunction

