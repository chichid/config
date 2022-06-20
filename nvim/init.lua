-------------------------
-- Plugins 
-------------------------
function load_plugins(use)
  use 'wbthomason/packer.nvim'
  use { 'ayu-theme/ayu-vim', event = 'VimEnter' }
  use { 'nvim-telescope/telescope.nvim', requires = {{'nvim-lua/plenary.nvim'}} }
end

-------------------------
-- Keyboard Mapping 
-- TODO convert to lua
-------------------------
vim.cmd [[
  noremap ! :!
  inoremap <expr>  <CR> pumvisible() ? "\<C-Y>" : "\<CR>"
  inoremap <expr>  <TAB> pumvisible() ? "\<C-y>" : "\<TAB>"
  inoremap <expr>  <C-j> pumvisible() ? "\<C-n>" : "\<Down>"
  inoremap <expr>  <C-k> pumvisible() ? "\<C-p>" : "\<Up>"
  inoremap <C-E> <C-o>$ 
  inoremap <C-a> <C-o>^
  inoremap <C-K> <C-o>d$
  inoremap <silent> <C-v> <C-o>:set paste<CR><C-r>*<C-o>:set nopaste<CR>

  vnoremap <silent> <C-c> "*ygv

  noremap <silent> <CR> :nohlsearch<CR>
  noremap <silent> <C-l> :b#<CR>
  noremap <silent> <C-k> :w!<CR>:RunExternal <UP><CR>
  noremap <silent> <expr> <C-b> exists("g:NERDTree") && g:NERDTree.IsOpen() ? ":NERDTreeClose<CR>" : ":NERDTreeToggle<CR><c-w><c-p>:NERDTreeFind<CR>"
  noremap <silent> <C-p> :lua open_telescope_picker("find_files", false)<CR>
  noremap <silent> ? :lua open_telescope_picker("current_buffer_fuzzy_find", false)<CR>
  noremap <silent> <C-f> :lua open_telescope_picker("live_grep", true)<CR>
  noremap <silent> <C-g> :lua open_telescope_picker("git_status", false)<CR>
]]

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

-------------------------
-- General 
-------------------------
vim.opt.loadplugins = false
vim.opt.termguicolors = true 
vim.opt.shell = "bash --login"
vim.opt.title = true
vim.opt.compatible = false 
vim.opt.backspace = "indent,eol,start"
vim.opt.number = true
vim.opt.wrap = true
vim.opt.encoding = "utf-8"
vim.opt.wildmenu = true
vim.opt.showmatch = true
vim.opt.ruler = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.linebreak = true
vim.opt.list = false 
vim.opt.history = 10000
vim.opt.textwidth = 0
vim.opt.wrapmargin = 0
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.laststatus = 0
vim.opt.mouse = "a"
vim.opt.splitright = true
vim.opt.guitablabel = "%t"
vim.opt.swapfile = false
vim.opt.cursorline = true
vim.opt.autoread = true
vim.opt.foldmethod = "indent"
vim.opt.foldlevel = 10
vim.opt.cindent = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.matchtime = 0
vim.opt.hidden = true
vim.opt.backup = false 
vim.opt.writebackup = false
vim.opt.cmdheight = 1

-------------------------
-- Custom Commands 
-------------------------
vim.api.nvim_create_user_command('RunExternal', function(command)
  cmd([[call RunCmd("{command.args}")]])
end, { nargs = '?' })

vim.api.nvim_create_user_command('Diff', function(command)
  cmd([[call OpenGitDiff("{command.args}")]])
end, { nargs = '?' })

vim.api.nvim_create_user_command('Config', function()
  vim.cmd[[ execute "e $MYVIMRC" ]]
end, {})

vim.api.nvim_create_user_command('ReloadConfig', function()
  vim.cmd[[ execute "luafile $MYVIMRC" ]]
end, {})

vim.api.nvim_create_user_command('Sync', function()
  vim.cmd[[ execute "luafile %" ]]
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
  local actions = require("telescope.actions")

  local mappings = {
    i = {
      ['<esc>'] = actions.close,
      ['<C-k>'] = actions.move_selection_previous,
      ['<C-j>'] = actions.move_selection_next,
    },
  }

  if (picker == "git_status") then
    mappings['i']['CR'] = function(prompt_bufnr)
      local action_state = require "telescope.actions.state"
      actions.close(prompt_bufnr)
      local selection = action_state.get_selected_entry()
      vim.cmd("call OpenGitDiff('" .. selection.path .. "')")
    end
  end 

  local picker_config = require('telescope.themes').get_dropdown({
    theme = 'dropdown',
    mappings = mappings,
    prompt_title = '',
    previewer = false,
    layout_config = {
      width = 0.7,
      height = 0.95
    },
  })

  require('telescope').setup {
    defaults = {
      mappings = mappings,
    },
    pickers = {
      git_status = {
        mappings = {
          i = {
            ["<CR>"] = function(prompt_bufnr)
              local action_state = require "telescope.actions.state"
              actions.close(prompt_bufnr)
              local selection = action_state.get_selected_entry()
              vim.cmd("call OpenGitDiff('" .. selection.path .. "')")
            end,
          },
        },
      },
    }
  }

  require('telescope.builtin')[picker](picker_config)
 end

-------------------------
-- Theme 
-------------------------
function load_theme() vim.cmd [[
  syntax on
  filetype plugin indent on

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
]] end 

vim.cmd [[ autocmd VimEnter * :lua load_theme() ]]

-------------------------
-- Floating term utility 
-- Todo: Convert to lua
-------------------------
vim.cmd[[ 
function! RunCmd(command)
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
-- TOOD: Convert to lua
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