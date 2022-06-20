"""""""""""""""
"" Plugins 
"""""""""""""""
function InitPlugins()
  Plug 'ayu-theme/ayu-vim'
  Plug 'townk/vim-autoclose'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle'  } 
  Plug 'mxw/vim-jsx', { 'for': ['tsx', 'jsx'] }
  Plug 'rust-lang/rust.vim', { 'for': ['rs', 'toml'] } 
  Plug 'leafgarland/typescript-vim', { 'for': ['tsx', 'ts'] }
  Plug 'neoclide/coc.nvim', {'branch': 'release', 'on': 'CocEnable'}
  Plug 'dinhhuy258/vim-local-history'
endfunction

""""""""""""
"" General
"""""""""""""
set noloadplugins
set shell=bash\ --login
set title
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
set guitablabel=%t
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
set hidden
set nobackup
set nowritebackup
set cmdheight=1
set shortmess+=c

""""""""""""""""""""
" Keyboard Mapping
""""""""""""""""""""
noremap ! :!
inoremap <expr>  <CR> pumvisible() ? "\<C-Y>" : "\<CR>"
inoremap <expr>  <TAB> pumvisible() ? "\<C-y>" : "\<TAB>"
inoremap <expr>  <C-j> pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr>  <C-k> pumvisible() ? "\<C-p>" : "\<Up>"
inoremap <C-E> <C-o>$ 
inoremap <C-a> <C-o>^
inoremap <C-K> <C-o>d$

vnoremap <silent> <C-c> "*y 

noremap <silent> <CR> :nohlsearch<CR>
noremap <silent> <C-l> :b#<CR>
noremap <silent> <C-K> :w<CR>:RunExternal <UP><CR>
noremap <silent> <expr> <C-b> exists("g:NERDTree") && g:NERDTree.IsOpen() ? ":NERDTreeClose<CR>" : ":NERDTreeToggle<CR><c-w><c-p>:NERDTreeFind<CR>"
noremap <silent> <C-p> :call OpenTelescopePicker("find_files", 0)<CR>
noremap <silent> ? :call OpenTelescopePicker("current_buffer_fuzzy_find", 0)<CR>
noremap <silent> <C-f> :call OpenTelescopePicker("live_grep", 1)<CR>
noremap <silent> <C-g> :call OpenTelescopePicker("git_status", 1)<CR>

"""""""""""""""""""""
" Custom Commands 
"""""""""""""""""""""
command ReloadConfig :source $MYVIMRC
command Config :e $MYVIMRC
command -nargs=1 ConfigModule execute ":e ".substitute($MYVIMRC, "init.vim", "lua/", "").<f-args>.".lua"
command -nargs=? RunExternal call RunInFloatingWindow(<q-args>)
command -nargs=? Diff :call OpenGitDiff(<q-args>) 

"""""""""""""""""""""
" Vim-Plug 
"""""""""""""""""""""
let auto_load_dir = has('nvim') ? stdpath('data').'/autoload' : '~/.vim/autoload'
let data_dir = has('nvim') ? stdpath('data').'/site' : '~/.vim'

if empty(glob(auto_load_dir.'/plug.vim')) 
  let tmp = data_dir.'/vim_plug_install_tmp'
  echo 'Installing Vim-Plug '.data_dir

  if empty(glob(auto_load_dir)) | silent execute '!mkdir -p '.auto_load_dir | endif
  if empty(glob(data_dir)) | silent execute '!mkdir -p '.data_dir | endif
  if empty(glob(tmp)) | silent execute '!mkdir -p '.tmp | endif
  if empty(glob(tmp.'/vim-plug')) | silent execute '!git '.' -C '.tmp.' clone https://github.com/junegunn/vim-plug' | endif
  if !empty(glob(tmp.'/vim-plug')) | silent execute '!mv '.tmp.'/vim-plug/plug.vim'.' '.auto_load_dir | endif
  if !empty(glob(tmp)) | silent execute '!rm -rf '.tmp | endif

  if !empty(glob(auto_load_dir.'/plug.vim'))
    echo 'Vim-Plug Was installed successfully'
    autocmd VimEnter * execute ":PlugInstall"
  else
    echoerr 'Unable to Install Vim-Plug'
  endif
endif

execute "source ".auto_load_dir."/plug.vim"

call plug#begin()
call InitPlugins()
call plug#end()

"""""""""""""
" Telescope 
""""""""""""""
lua << EOF
local actions = require("telescope.actions")
local picker_config = {
  theme = 'dropdown',
  prompt_title = '',
  previewer = false,
  layout_config = {
    width = 0.7,
    height = 0.95
  },
};

require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ["<esc>"] = actions.close,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-j>"] = actions.move_selection_next,
      },
    },
  },
  pickers = {
    live_grep = picker_config, 
    current_buffer_fuzzy_find = picker_config, 
    find_files = picker_config,
    git_status = {
      theme = 'dropdown',
      prompt_title = '',
      previewer = false,
      layout_config = {
        width = 0.7,
        height = 0.95
      },
      mappings = {
        i = {
          ["<CR>"] = function(prompt_bufnr)
            local action_state = require "telescope.actions.state"
            actions.close(prompt_bufnr)
            local selection = action_state.get_selected_entry()
            vim.cmd("call OpenGitDiff('" .. selection.path .. "')")
          end,
        }
      }
    },
  },
}

EOF

let last_telescope_picker = ""

function! OpenTelescopePicker(picker, resume) abort
  if &diff
    return
  endif

  if exists("g:NERDTree") && g:NERDTree.IsOpen()
    execute "NERDTreeClose"
  endif

  if g:last_telescope_picker == a:picker && a:resume
    execute "Telescope resume"
  else
    let g:last_telescope_picker = a:picker
    execute "Telescope ".a:picker
  endif
endfunction

"""""""""""""
" NERDTree
""""""""""""""
let g:NERDTreeMinimalUI = 1
let g:NERDTreeDirArrowExpandable = ''
let g:NERDTreeQuitOnOpen = 1
let g:NERDTreeMapHelp = 'H'

""""""""""""""
" Theme
""""""""""""""
function! InitTheme() 
  syntax on
  filetype plugin indent on

  if !(&runtimepath =~? "ayu")
    echo "Ayu Theme is not available"
    return
  endif

  set termguicolors     
  let ayucolor="dark" 
  colorscheme ayu

  hi Normal guibg=black
  hi EndOfBuffer ctermfg=black guifg=black
  hi SignColumn guibg=NONE ctermbg=NONE
  hi TabLine ctermbg=grey ctermfg=black guibg=#1f2430
  hi TabLineSel ctermbg=black ctermfg=white guibg=white guifg=black
  hi TabLineFill ctermfg=black guifg=black
  hi Visual cterm=none ctermbg=darkgrey ctermfg=white
  hi Search cterm=none ctermbg=darkgrey ctermfg=white
  hi MatchParen ctermfg=white ctermbg=darkgrey
  hi CursorLineNr term=bold ctermfg=white
  hi LineNr guifg=#4E4E4E
  hi FloatBorder ctermfg=white

  " Diff Colors
  hi DiffDelete ctermbg=None ctermfg=Black gui=none guifg=#14191F guibg=#14191F
  hi DiffText cterm=bold gui=bold ctermfg=225 guifg=#FF7733 ctermbg=Green guibg=#253b26
  au WinEnter * if !(&diff) | hi DiffAdd ctermbg=none guibg=none | endif
  au WinEnter * if  (&diff) | hi DiffAdd ctermbg=none ctermbg=Green guibg=#19261e | endif
  au WinEnter * if !(&diff) | hi DiffChange ctermbg=none guibg=none | endif
  au WinEnter * if  (&diff) | hi DiffChange ctermbg=none ctermbg=Green guibg=#19261e | endif
endfunction
call InitTheme() 

""""""""""""""""""
" WSL yank support
""""""""""""""""""
"let s:clip = '/mnt/c/Windows/System32/clip.exe'  " change this path according to your mount point
"if executable(s:clip)
"    augroup WSLYank
"        autocmd!
"        autocmd TextYankPost * if v:event.operator ==# 'y' | call system(s:clip, @0) | endif
"    augroup END
"endif

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
  setlocal buftype=nofile
  setlocal bufhidden=hide
  setlocal noswapfile

  execute "term " . a:command

  map <buffer> <C-c> "*y
  map <buffer> j <C-e>
  map <buffer> k <C-y>
  map <buffer> <silent> <ESC> :close<CR>
  map <buffer> <silent> <CR> :close<CR>
endfunction

"""""""""""""
" Git 
""""""""""""""
autocmd BufWritePost * if &diff == 1 | diffupdate | endif

function! OpenGitDiff(input)
  function! DiffKeyBinding()
    nmap <silent> <buffer> <C-j> ]czz
    nmap <silent> <buffer> <C-k> [czz
    nmap <silent> <expr> <buffer> u &ma ? "u":":wincmd p\<cr>:normal u\<cr>:wincmd p\<cr>"
    nmap <silent> <expr> <buffer> <C-r> &ma ? "\<C-r>":":wincmd p\<cr>\<C-r>:wincmd p\<cr>"
    nmap <silent> <expr> <buffer> <C-u> &ma ? "\<c-v>:'<,'>diffget\<cr>:diffupdate\<cr>":"\<c-v>:'<,'>diffput\<cr>:diffupdate\<cr>"
    vmap <silent> <expr> <buffer> <C-u> &ma ? ":'<,'>diffget\<cr>:diffupdate\<cr>":":'<,'>diffput\<cr>:diffupdate\<cr>"
  endfunction

  """ Git Initialization
  set diffopt=filler,foldcolumn:0
  let root = systemlist("git rev-parse --show-toplevel")[0]
  if v:shell_error != 0 | return | endif

  let input = substitute(a:input, root."/", "", "")
  let git_cmd = "git --no-pager show HEAD:".input
  call system(git_cmd)
  let exists = v:shell_error == 0

  let cmd = "cd " .root. " && " . git_cmd

  """ Modifable code window (Right) 
  if !(line('$') == 1 && getline(1) == '')
    execute ":tabnew"
  endif

  execute ":e ".a:input
  call DiffKeyBinding()
  diffthis
  diffupdate
  set nofoldenable

  "" Diff Window
  let filetype = &filetype
  lefta vertical new
  call DiffKeyBinding()
  setlocal noswapfile
  setlocal buftype=nofile
  let &filetype=filetype
  if exists | silent! execute "read ++edit !".cmd | endif 
  diffthis
  diffupdate
  setlocal nomodifiable 
  setlocal nofoldenable

  execute ":goto"
  wincmd p 
  execute ":e"

  au WinClosed * ++once silent! diffoff 
  au WinClosed * ++once silent! execute ":q" 
  au WinClosed * ++once silent! execute ":q" 
endfunction

"""""""""""""
" Hex Editor
""""""""""""""
autocmd VimEnter *.bin call InitBinarySupport()

function InitBinarySupport()
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
endfunction

"""""""""""""""""""""""
" Startup Optimization 
"""""""""""""""""""""""
let g:loaded_gzip = 1
let g:loaded_tar = 1
let g:loaded_tarPlugin = 1
let g:loaded_zip = 1
let g:loaded_zipPlugin = 1

let g:loaded_getscript = 1
let g:loaded_getscriptPlugin = 1
let g:loaded_vimball = 1
let g:loaded_vimballPlugin = 1

let g:loaded_matchit = 1
let g:loaded_matchparen = 1
let g:loaded_2html_plugin = 1
let g:loaded_logiPat = 1
let g:loaded_rrhelper = 1

let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1
let g:loaded_netrwSettings = 1
let g:loaded_netrwFileHandlers = 1
