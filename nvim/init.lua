------------------------
-- Plugins 
-------------------------
function load_plugins(use)
  use { 'wbthomason/packer.nvim' }
  use { 'ayu-theme/ayu-vim' }
  use { 'airblade/vim-rooter', opt = true }
  use { 'kyazdani42/nvim-tree.lua', opt = true }
  use { 'nvim-telescope/telescope.nvim', opt = true, requires = {{'nvim-lua/plenary.nvim'}} }
  use { 'dense-analysis/ale', opt = true } 
end

-------------------------
-- Keyboard Mapping 
-------------------------
vim.cmd [[
  cabbrev h vert help
  cabbrev help vert help
  cabbrev copen vert copen
  cabbrev lopen vert lopen
]]

vim.cmd [==[
  map <C-z> :CloseAll<CR> "" this is important for Wezterm intergation
  map <C-c> "*ygv
  inoremap <silent> <C-v> <C-o>:set paste<CR><C-r>*<C-o>:set nopaste<CR>

  noremap <silent> <F7> :ALEPrevious<CR>
  noremap <silent> <F8> :ALENext<CR>
  noremap <silent> <C-j> :vert lopen<CR><C-w>h<C-w>l
  autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>
  autocmd BufReadPost quickfix nnoremap <buffer> <space> <CR><C-w>l

  noremap <C-h> viw"hy:%s/<C-r>h/<C-r>h/g<left><left>
  vnoremap <C-h> "hy:%s/<C-r>h/<C-r>h/g<left><left>
  noremap <S-h> viw"hy:vimgrep "<C-r>h" **/*<left><left><left><left><left><left> 
  vnoremap <S-h> "hy:vimgrep "<C-r>h" **/*<left><left><left><left><left><left><left> 

  noremap <silent> n nzz
  noremap <silent> N Nzz
  noremap <silent> <CR> :nohlsearch<CR>
  noremap <silent> <C-l> :b#<CR>
  noremap <C-k> :w!<CR>:RunExternal <UP><CR>
  noremap <silent> <C-p> :lua open_telescope_picker("find_files", false)<CR>
  noremap <silent> <C-F> :lua open_telescope_picker("current_buffer_fuzzy_find", false)<CR>
  noremap <silent> <C-f> :lua open_telescope_picker("live_grep", true)<CR>
  noremap <silent> <C-g> :lua open_telescope_picker("git_status", false)<CR>
  noremap <silent> <C-b> :lua open_nvim_tree()<CR>
]==]

-- Cross session yank and paste (Better than clipboard)
--vim.cmd [[
--  autocmd TextYankPost * call writefile([getreg('"')], $VIM..'/.clipboard')
--  nnoremap <silent> p :call setreg('"', join(readfile($VIM..'/.clipboard'), '\n'))<CR>p
--  nnoremap <silent> P :call setreg('"', join(readfile($VIM..'/.clipboard'), '\n'))<CR>P
--]]

-------------------------
-- General 
-------------------------
vim.opt.loadplugins = false
vim.opt.confirm= true 
vim.opt.shell = "bash --login"
vim.opt.title = true
vim.opt.compatible = false 
vim.opt.backspace = "indent,eol,start"
vim.opt.number = true
vim.opt.wrap = false 
vim.opt.wrapmargin = 0
vim.opt.encoding = "utf-8"
vim.opt.wildmenu = true
vim.opt.showmatch = true
vim.opt.matchtime = 1
vim.opt.ruler = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.linebreak = true
vim.opt.list = false 
vim.opt.history = 10000
vim.opt.textwidth = 0
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.laststatus = 0
vim.opt.mouse = "a"
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.cursorline = true
vim.opt.autoread = true
vim.opt.foldmethod = "indent"
vim.opt.foldlevel = 10
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.cindent = true 
vim.opt.hidden = true
vim.opt.backup = false 
vim.opt.writebackup = false
vim.opt.cmdheight = 1
vim.opt.winwidth = math.floor(vim.fn.winwidth(0)*0.6)

-------------------------
-- Indent 
-------------------------
vim.cmd[[
autocmd FileType * call InitIndent()

function! InitIndent()
  set cindent
  set cino=(4
endfunction 
]]

-------------------------
-- Custom Commands 
-------------------------
vim.cmd[[
  command! Ammend !git add -A && git commit --amend --no-edit
  command! -nargs=1 Commit !git add -A && git commit -am <q-args>
  command! -nargs=* Push !git push <f-args>
  command! Status !git status
]]

vim.api.nvim_create_user_command('CloseAll', function(command)
  cmd([[
    if execute("ls +") != ''
      echo "
      if nr2char(getchar()) == 'y'
        execute "cq"
      else
        execute "normal :<ESC>"
      endif
    else
      execute "cq"
    endif
  ]])
end, { nargs = '?' })

vim.api.nvim_create_user_command('Ale', function(command)
  cmd [[
    let g:ale_lint_on_text_changed = 'never'
    let g:ale_lint_on_insert_leave = 0
    let g:ale_lint_on_enter = 0
    let g:ale_list_vertical = 1
    let g:ale_sign_error = ' |'
    let g:ale_sign_warning = ' |'
    let g:ale_rust_cargo_check_all_targets = 1
    packadd ale
    :ALEEnable
    :ALELint
  ]]
end, { nargs = '?' })

vim.api.nvim_create_user_command('RenameSymbol', function(command)
  cmd [[
    packadd coc.nvim
    :CocEnable
  ]]
end, { nargs = '?' })

vim.api.nvim_create_user_command('RunExternal', function(command)
  cmd([[
    try
      :exec "norm :ALEToggle<CR>"
      :exec "norm :lclose<CR>"
    endtry
  ]])
  cmd([[call RunCmd("{command.args}")]])
end, { nargs = '?' })

vim.api.nvim_create_user_command('Diff', function(command)
  cmd([[call OpenGitDiff("{command.args}")]])
end, { nargs = '?' })

vim.api.nvim_create_user_command('Config', function()
  vim.cmd[[ 
    execute "e $MYVIMRC" 
    cd %:p:h
  ]]
end, {})

vim.api.nvim_create_user_command('ReloadConfig', function()
  vim.cmd[[ execute "luafile $MYVIMRC" ]]
end, {})

vim.api.nvim_create_user_command('Sync', function()
  vim.cmd[[ execute "ReloadConfig" ]]
  require('packer').sync()
end, {})

-------------------------
-- Packer 
-------------------------
function init_packer() 
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

  if fn.empty(fn.glob(install_path)) > 0 then
    print("Installing Packer...")
    packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    print("Packer Installed Successfully!")
  end

  require('packer').startup(load_plugins)
end init_packer()

-------------------------
-- Telescope 
-------------------------
function open_telescope_picker(picker) 
  cmd [[ packadd plenary.nvim ]]
  cmd [[ packadd telescope.nvim ]]

  local telescope = require 'telescope'
  local actions = require 'telescope.actions'
  local themes = require 'telescope.themes'

  local mappings = {
    i = {
      ['<esc>'] = actions.close,
      ['<C-k>'] = actions.move_selection_previous,
      ['<C-j>'] = actions.move_selection_next,
    },
  }

  local picker_config = themes.get_dropdown({
    theme = 'dropdown',
    mappings = mappings,
    prompt_title = '',
    previewer = false,
    winblend = 10,
    borderchars = {
      prompt = { "─", "│", " ", "│", "┌", "┐", "│", "│" },
      results = { "─", "", "", "", "└", "┘", "", "" },
      preview = { "─", "", "", "", "└", "┘", "", "" },
    },
    layout_config = {
      anchor = 'N',
      width = 0.5,
      height = 0.9, 
    }
  })

  --- Git Integration 
  if (picker == 'git_status') then 
     mappings = {
      i = {
        ['<esc>'] = actions.close,
        ['k'] = actions.move_selection_previous,
        ['j'] = actions.move_selection_next,
        ["<CR>"] = function(prompt_bufnr)
          local action_state = require "telescope.actions.state"
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          vim.cmd("call OpenGitDiff('" .. selection.path .. "')")
        end,
      },
    }
  end

  telescope.setup {
    defaults = {
      mappings = mappings,
    },
    pickers = {
      git_status = {
        mappings = mappings
      },
    },
    extensions = {
      file_browser = picker_config, 
    },
  }

  require'telescope.builtin'[picker](picker_config)
end

-------------------------
-- NvimTree 
-------------------------
function setup_nvim_tree() 
  local config =  {
    renderer = {
      icons = {
        webdev_colors = false,
        show = {
          file = false,
          folder = true,
          folder_arrow = true,
          git = false,
        },
      },
    },
    view = {
      signcolumn = "no",
      width = 40,
      mappings = {
        list = {
          { key = "i", action = "close_node" },
          { key = "<Left>", action = "close_node" },
          { key = "l", action = "edit" },
          { key = "<Right>", action = "edit" },
        },
      },
    },
    filters = {
      dotfiles = true,
    },
    live_filter = {
      prefix = "[FILTER]: ",
      always_show_folders = false,
    },
    actions = {
      open_file = {
        quit_on_open = false,
      },
      expand_all = {
        max_folder_discovery = 300,
      },
    },
  }

  if not vim.g["loaded_nvimTree"] then
    cmd [[ packadd nvim-tree.lua ]]
    require("nvim-tree").setup(config)
    cmd [[ let g:loaded_nvimTree = 1 ]]
  end
end

function open_nvim_tree()
  local current_winwidth = vim.api.nvim_get_option("winwidth")

  setup_nvim_tree()

  cmd [[ 
    setlocal winwidth=1
    execute "NvimTreeFindFileToggle"
    execute "wincmd p" 
    setlocal winwidth={current_winwidth}
    execute "wincmd p" 
  ]]
end

function toggle_nvim_tree()
  local current_winwidth = vim.api.nvim_get_option("winwidth")

  setup_nvim_tree()

  cmd [[ 
    setlocal winwidth=1
    execute "NvimTreeToggle"
    execute "wincmd p" 
    setlocal winwidth={current_winwidth}
    execute "wincmd p" 
  ]]
end
-------------------------
-- Color Scheme 
-------------------------
vim.cmd [[ autocmd VimEnter * :lua load_theme() ]]

function load_theme() vim.cmd [[ try
  if $TERM_PROGRAM !=? 'Apple_Terminal' && $TERM ==? 'xterm-256color'
    set termguicolors
    let ayucolor="dark" 
    colorscheme ayu
  else
    colorscheme delek 
    hi CursorLine ctermbg=lightgray ctermfg=black
    throw l:output
  endif

  " for ayu dark hi Invisible ctermbg=0 guibg=black
  hi InvisibleText ctermfg=black guifg=#0f1419
  hi link EndOfBuffer InvisibleText
  hi FloatBorder guifg=#3D4751
  
  " Search
  hi Search cterm=bold gui=bold ctermbg=cyan guibg=#5C6773 guifg=white

  " Vert Split
  set fillchars+=vert:│
  hi VertSplit ctermbg=NONE guibg=NONE guifg=#151A1E

  " Diff Colors
  hi DiffDelete guifg=#212733 guibg=#272D38
  hi DiffText cterm=bold gui=bold ctermfg=225 guifg=#FF7733 ctermbg=Green guibg=#253b26

  " NvimTree
  hi NvimTreeFolderName guifg=#5C6773 gui=none
  hi link NvimTreeFolderIcon NvimTreeFolderName
  hi link NvimTreeExecFile NvimTreeFolderName
  hi link NvimTreeSpecialFile NvimTreeFolderName 
  hi NvimTreeOpenedFile guifg=#F29718 gui=bold
  hi link NvimTreeRootFolder NvimTreeOpenedFile 
  hi NvimTreeCursorLine guifg=#E6E1CF guibg=#253340 gui=bold

  " Telescope
  hi TelescopeNormal guibg=#3D4751
  hi TelescopePromptBorder guibg=#3D4751 guifg=#c4a25f
  hi TelescopeResultsBorder guibg=#3D4751 guifg=#c4a25f
  hi TelescopePromptCounter guifg=lightgrey

  function! HI()
    for id in synstack(line("."), col("."))
      echo synIDattr(id, "name")
    endfor
  endfunction
  command! -nargs=0 HI call HI()

  catch 
    echo "No term gui colors for you!"
  endtry
]] end 

-------------------------
-- Floating term utility 
-------------------------
vim.cmd[[ function! RunCmd(command)
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
endfunction ]] 

-------------------------
-- Git 
-------------------------
vim.cmd [[ 
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
endfunction ]]

-------------------------
-- Hex Editor 
-------------------------
vim.cmd[[
autocmd VimEnter *.bin call InitBinarySupport()

function! InitBinarySupport()
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
endfunction ]]

---------------------------
-- Fucking Windows 
---------------------------
vim.cmd[[
let s:clip = '/mnt/c/Windows/System32/clip.exe' 
if executable(s:clip)
  let g:clipboard = {
  \   'name': 'win32yank.exe',
  \   'copy': {
  \      '*': 'clip.exe',
  \    },
  \   'paste': {
  \      '*': 'clip.exe',
  \   },
  \   'cache_enabled': 0,
  \ }
endif
]] 

-------------------------
-- Utility Functions 
-------------------------
function f(str)
   local outer_env = _ENV
   return (str:gsub("%b{}", function(block)
      local code = block:match("{(.*)}")
      local exp_env = {}
      setmetatable(exp_env, { __index = function(_, k)
         local stack_level = 5
         while debug.getinfo(stack_level, "") ~= nil do
            local i = 1
            repeat
               local name, value = debug.getlocal(stack_level, i)
               if name == k then
                  return value
               end
               i = i + 1
            until name == nil
            stack_level = stack_level + 1
         end
         return rawget(outer_env, k)
      end })
      local fn, err = load("return "..code, "expression `"..code.."`", "t", exp_env)
      if fn then
         return tostring(fn())
      else
         error(err, 0)
      end
   end))
end

function cmd(str) 
  vim.cmd(f(str))
end

-------------------------
-- Startup Optimization 
-------------------------
vim.g.loaded_gzip = 1
vim.g.loaded_ftp = 1
vim.g.loaded_ftpPlugin = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_logiPat = 1
vim.g.loaded_rrhelper = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1
vim.g.loaded_netrwFileHandlers = 1
