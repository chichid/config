local wezterm = require 'wezterm'
local act = wezterm.action
 
local default_prog
local default_cwd
local font_size
local tab_font_size
local initial_rows
local inital_cols

if string.find(wezterm.target_triple, "windows") then
  default_prog = {"wsl.exe"}; 
  default_cwd = "~";
  tab_font_size = 9.0;
  font_size = 10.5;
  initial_rows = 43;
  initial_cols = 180;
end

if string.find(wezterm.target_triple, "darwin") then
  tab_font_size = 15.0;
  font_size = 16;
  initial_rows = 38;
  initial_cols = 120;
end

local keys = {
  -- Keyboard Navigation
  -- Ctrl+f/F
  { key="f", mods="CTRL", action={SendKey={key="f", mods="CTRL"}} },
  { key="f", mods="CMD", action={SendKey={key="f", mods="CTRL"}} },
  { key="F", mods="CTRL", action={SendKey={key="F", mods="CTRL"}} },
  { key="F", mods="CMD", action={SendKey={key="F", mods="CTRL"}} },

  --- delete words backwards 
  { key="Backspace", mods="ALT", action={SendKey={key="W", mods="CTRL"}} },
  { key="Backspace", mods="ALT", action={SendKey={key="W", mods="CTRL"}} },
  { key="Backspace", mods="CTRL", action={SendKey={key="U", mods="CTRL"}} },
  { key="Backspace", mods="CMD", action={SendKey={key="U", mods="CTRL"}} },

  --- home and end 
  { key="LeftArrow", mods="CTRL", action={SendKey={key="Home"}} },
  { key="LeftArrow", mods="CMD", action={SendKey={key="Home"}} },
  { key="RightArrow", mods="CTRL", action={SendKey={key="End"}} },
  { key="RightArrow", mods="CMD", action={SendKey={key="End"}} },

  --- move one word
  { key="LeftArrow", mods="ALT", action={SendKey={key="LeftArrow", mods="CTRL"}} },
  { key="RightArrow", mods="ALT", action={SendKey={key="RightArrow", mods="CTRL"}} },

  --- ctrl + jk keyboard navigation 
  { key="k", mods="CTRL", action={SendKey={key="UpArrow"}} },
  { key="k", mods="ALT", action={SendKey={key="UpArrow"}} },
  { key="k", mods="CMD", action={SendKey={key="UpArrow"}} },
  { key="j", mods="CTRL", action={SendKey={key="DownArrow"}} },
  { key="j", mods="ALT", action={SendKey={key="DownArrow"}} },
  { key="j", mods="CMD", action={SendKey={key="DownArrow"}} },

  --- accept completion on ctrl|alt|cmd + .
  { key=".", mods="CTRL", action={SendKey={key="RightArrow"}} },
  { key=".", mods="ALT" , action={SendKey={key="RightArrow"}} },
  { key=".", mods="CMD" , action={SendKey={key="RightArrow"}} },

  -- Fullscreen
  { key="Enter", mods="CTRL", action= "ToggleFullScreen" },
  { key="Enter", mods="CMD", action= "ToggleFullScreen" },
  { key="Enter", mods="ALT", action= "ToggleFullScreen" },

  -- Clear Screen
  { key="l", mods="CMD", action={SendKey={key="l", mods="CTRL"}}},
  { key="l", mods="ALT", action={SendKey={key="l", mods="CTRL"}}},
  { key="k", mods="CMD", action={SendKey={key="l", mods="CTRL"}}},
  { key="k", mods="ALT", action={SendKey={key="l", mods="CTRL"}}},
  
  -- Copy/Paste 
  { key="c", mods="ALT", action={EmitEvent = "ClipboardCopy"} },
  { key="c", mods="CMD", action={EmitEvent = "ClipboardCopy"} },
  { key="c", mods="CTRL", action={EmitEvent = "ClipboardCopy"} },
  { key="v", mods="ALT", action={EmitEvent = "ClipboardPaste"} },
  { key="v", mods="CMD", action={EmitEvent = "ClipboardPaste"} },
  { key="v", mods="CTRL", action={EmitEvent = "ClipboardPaste"} },
  
  -- Open New Window 
  { key="t", mods="CMD", action={SpawnTab="CurrentPaneDomain"} },
  { key="t", mods="ALT", action={SpawnTab="CurrentPaneDomain"} },
  { key="t", mods="CTRL", action={SpawnTab="CurrentPaneDomain"} },
  { key="n", mods="CMD", action="SpawnWindow" },
  { key="n", mods="ALT", action="SpawnWindow" },
  { key="n", mods="CTRL", action="SpawnWindow" },
  { key="w", mods="CMD", action={EmitEvent = "CloseCurrentTab"} },
  { key="w", mods="ALT", action={EmitEvent = "CloseCurrentTab"} },
  { key="w", mods="CTRL", action={EmitEvent = "CloseCurrentTab"} },

  -- Open the config
  { key=",", mods="CTRL", action={SendString="vim ~/.config/wezterm/wezterm.lua\r\n"}},
  { key=",", mods="ALT", action={SendString="vim ~/.config/wezterm/wezterm.lua\r\n"}},
  { key=",", mods="CMD", action={SendString="vim ~/.config/wezterm/wezterm.lua\r\n"}},

  -- Move tabs
  { key = 'LeftArrow', mods = 'SHIFT|ALT', action = act.MoveTabRelative(-1) },
  { key = 'LeftArrow', mods = 'SHIFT|CMD', action = act.MoveTabRelative(-1) },
  { key = 'RightArrow', mods = 'SHIFT|ALT', action = act.MoveTabRelative(1) },
  { key = 'RightArrow', mods = 'SHIFT|CMD', action = act.MoveTabRelative(1) },
};

-- ALT-Tab
for i = 1, 9 do 
  table.insert(keys, { key=tostring(i), mods="CMD", action=wezterm.action{ActivateTab=i-1} })
  table.insert(keys, { key=tostring(i), mods="ALT", action=wezterm.action{ActivateTab=i-1} })
  table.insert(keys, { key=tostring(i), mods="CTRL", action=wezterm.action{ActivateTab=i-1} });
end

function is_vim(pane)
  local current_process = pane:get_title():upper()
  return 
    current_process:sub(-#"NVIM") == "NVIM" or current_process:sub(1, #"NVIM") == "NVIM" or 
    current_process:sub(-#"VIM") == "VIM" or current_process:sub(1, #"VIM") == "VIM" or 
    current_process:sub(-#"VI") == "VI" or current_process:sub(1, #"VI") == "VI"
end

wezterm.on("CloseCurrentTab", function(window, pane)
  if is_vim(pane) then
    window:perform_action(wezterm.action{ SendKey={key="Z", mods="CTRL"} }, pane)
  else
    window:perform_action(wezterm.action{ CloseCurrentTab={confirm=false} }, pane)
  end
end)

wezterm.on("ClipboardCopy", function(window, pane)
  if is_vim(pane) then
    window:perform_action(wezterm.action{ SendKey={key="c", mods="CTRL"} }, pane)
  else
    window:perform_action(wezterm.action.CopyTo "ClipboardAndPrimarySelection", pane)
  end
end)

wezterm.on("ClipboardPaste", function(window, pane)
  window:perform_action(wezterm.action.PasteFrom "Clipboard", pane)
end)

return {
  -- General
  default_prog = default_prog,
  exit_behavior = "Close",
  default_cwd = default_cwd,

  -- Key Bindings
  keys = keys,  

  -- Window
  initial_rows = initial_rows,
  initial_cols = initial_cols,
  window_padding = { left = 0, right = 0, top = 0, bottom = 0 },

  -- Mac Os
  native_macos_fullscreen_mode = true,

  -- Appearance and Colors 
  color_scheme = "Molokai",
  window_decorations = "RESIZE",
  color_schemes = color_schemes,
  default_cursor_style = "SteadyBlock",
  audible_bell = "Disabled",
  font = wezterm.font('JetBrains Mono'),
  font_size = font_size,
  font_locator = 'ConfigDirsOnly',
  harfbuzz_features = {"calt=0", "clig=0", "liga=0"},
  window_frame = { font_size = tab_font_size, },
  prefer_egl = true,
  check_for_updates = false
}
