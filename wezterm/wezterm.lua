local wezterm = require 'wezterm';
 
local default_prog;
local default_cwd;
local font_size;
local tab_font_size;
local initial_rows;
local inital_cols;

if string.find(wezterm.target_triple, "windows") then
  default_prog = {"wsl.exe"}; 
  default_cwd = os.getenv("HOME");
  tab_font_size = 9.0;
  font_size = 10.7;
  initial_rows = 42;
  initial_cols = 160;
end

if string.find(wezterm.target_triple, "darwin") then
  tab_font_size = 15.0;
  font_size = 16;
  initial_rows = 38;
  initial_cols = 120;
end

local mouse_bindings = {
  -- Right Click to paste 
  { event={Down={streak=1, button="Right"}}, mods="NONE", action="Paste" },
};

local keys = {
  -- Keyboard Navigation
  { key="Backspace", mods="CTRL", action={SendKey={key="U", mods="CTRL"}} },
  { key="Backspace", mods="CMD", action={SendKey={key="U", mods="CTRL"}} },
  { key="Backspace", mods="ALT", action={SendKey={key="W", mods="CTRL"}} },

  { key="LeftArrow", mods="CTRL", action={SendKey={key="a", mods="CTRL"}} },
  { key="LeftArrow", mods="CMD", action={SendKey={key="a", mods="CTRL"}} },
  { key="LeftArrow", mods="ALT", action={SendKey={key="b", mods="ALT"}} },

  { key="RightArrow", mods="CTRL", action={SendKey={key="E", mods="CTRL"}} },
  { key="RightArrow", mods="CMD", action={SendKey={key="E", mods="CTRL"}} },

  { key="RightArrow", mods="ALT", action={SendKey={key="f", mods="ALT"}} },

  { key=".", mods="CTRL", action={SendKey={key="RightArrow"}} },
  { key=".", mods="ALT" , action={SendKey={key="RightArrow"}} },
  { key=".", mods="CMD" , action={SendKey={key="RightArrow"}} },

  -- Fullscreen
  { key="Enter", mods="CTRL", action= "ToggleFullScreen" },
  { key="Enter", mods="CMD", action= "ToggleFullScreen" },
  { key="Enter", mods="ALT", action= "ToggleFullScreen" },

  -- Clear Screen
  { key="k", mods="ALT", action=wezterm.action{SendString="printf '\\033c'\n"}},
  { key="k", mods="CMD", action=wezterm.action{SendString="printf '\\033c'\n"}},
  { key="l", mods="CMD", action={SendKey={key="l", mods="CTRL"}}},
  { key="l", mods="ALT", action={SendKey={key="l", mods="CTRL"}}},
  
  -- Copy/Paste 
  { key="c", mods="ALT", action="Copy" },
  { key="c", mods="CMD", action="Copy" },
  { key="v", mods="ALT", action="Paste" },
  { key="v", mods="CMD", action="Paste" },
  { key="v", mods="CTRL", action={SendKey={key="v", mods="CTRL"}} },
  
  -- Open New Window 
  { key="t", mods="CMD", action=wezterm.action{SpawnTab="CurrentPaneDomain"} },
  { key="t", mods="ALT", action=wezterm.action{SpawnTab="CurrentPaneDomain"} },
  { key="n", mods="CMD", action="SpawnWindow" },
  { key="n", mods="ALT", action="SpawnWindow" },
  { key="w", mods="ALT", action=wezterm.action{CloseCurrentTab={confirm=false}}},

  -- Open the config
  { key=",", mods="ALT", action=wezterm.action{SendString="vim ~/.config/wezterm/wezterm.lua\r\n"}},
  { key=",", mods="CMD", action=wezterm.action{SendString="vim ~/.config/wezterm/wezterm.lua\r\n"}},
};

-- Tab Navigation
for i = 1, 9 do 
  table.insert(keys, { key=tostring(i), mods="ALT", action=wezterm.action{ActivateTab=i-1} })
  table.insert(keys, { key=tostring(i), mods="CTRL", action=wezterm.action{ActivateTab=i-1} });
end

-- Color Scheme
local color_schemes = {
  ["ayu"] = {
    foreground = "#e6e1cf",
    background = "black",
    cursor_bg = "#f29718",
    cursor_border = "#f29718",
    cursor_fg = "#e6e1cf",
    selection_bg = "#253340",
    selection_fg = "#e6e1cf",
    ansi = {"#000000","#ff3333","#b8cc52","#e7c547","#36a3d9","#f07178","#95e6cb","#ffffff"},
    brights = {"#323232","#ff6565","#eafe84","#fff779","#68d5ff","#ffa3aa","#c7fffd","#ffffff"},
  },
};

return {
  -- General
  window_close_confirmation = "NeverPrompt",
  default_prog = default_prog,
  default_cwd = default_cwd,

  -- Key Bindings
  keys = keys,  
  mouse_bindings = mouse_bindings,

  -- Window
  initial_rows = initial_rows,
  initial_cols = initial_cols,
  window_padding = { left = 1, right = 1, top = 0, bottom = 0 },

  -- Appearance and Colors 
  color_scheme = "ayu",
  window_decorations = "RESIZE",
  color_schemes = color_schemes,
  default_cursor_style = "BlinkingBlock",
  audible_bell = "Disabled",
  font_size = font_size,
  window_frame = {
    font_size = tab_font_size,
  }
}
