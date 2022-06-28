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

local keys = {
  -- Keyboard Navigation
  --- delete words backwards 
  { key="Backspace", mods="CTRL", action={SendKey={key="U", mods="CTRL"}} },
  { key="Backspace", mods="CMD", action={SendKey={key="U", mods="CTRL"}} },
  { key="Backspace", mods="ALT", action={SendKey={key="W", mods="CTRL"}} },

  --- home and end 
  { key="LeftArrow", mods="CTRL", action={SendKey={key="Home"}} },
  { key="LeftArrow", mods="CMD", action={SendKey={key="Home"}} },
  { key="RightArrow", mods="CTRL", action={SendKey={key="End"}} },
  { key="RightArrow", mods="CMD", action={SendKey={key="End"}} },

  --- move one word
  { key="LeftArrow", mods="ALT", action={SendKey={key="LeftArrow", mods="CTRL"}} },
  { key="RightArrow", mods="ALT", action={SendKey={key="RightArrow", mods="CTRL"}} },

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
  
  -- Copy/Paste 
  { key="c", mods="ALT", action="Copy" },
  { key="c", mods="CMD", action="Copy" },
  { key="v", mods="ALT", action="Paste" },
  { key="v", mods="CMD", action="Paste" },
  
  -- Open New Window 
  { key="t", mods="CMD", action=wezterm.action{SpawnTab="CurrentPaneDomain"} },
  { key="t", mods="ALT", action=wezterm.action{SpawnTab="CurrentPaneDomain"} },
  { key="n", mods="CMD", action="SpawnWindow" },
  { key="n", mods="ALT", action="SpawnWindow" },
  { key="w", mods="ALT", action=wezterm.action{CloseCurrentTab={confirm=true}}},

  -- Open the config
  { key=",", mods="ALT", action=wezterm.action{SendString="vim ~/.config/wezterm/wezterm.lua\r\n"}},
  { key=",", mods="CMD", action=wezterm.action{SendString="vim ~/.config/wezterm/wezterm.lua\r\n"}},
};

-- Tab Navigation
for i = 1, 9 do 
  table.insert(keys, { key=tostring(i), mods="ALT", action=wezterm.action{ActivateTab=i-1} })
  table.insert(keys, { key=tostring(i), mods="CTRL", action=wezterm.action{ActivateTab=i-1} });
end

-- Colors 
local colors = {
  tab_bar = {
    active_tab = {
      bg_color = "#212733",
      fg_color = "#D9D7CE",
    },
  },
}

return {
  -- General
  default_prog = default_prog,
  default_cwd = default_cwd,
  colors = colors,

  -- Key Bindings
  keys = keys,  

  -- Window
  initial_rows = initial_rows,
  initial_cols = initial_cols,
  window_padding = { left = 1, right = 1, top = 0, bottom = 0 },

  -- Appearance and Colors 
  color_scheme = "Ayu Mirage",
  window_decorations = "RESIZE",
  color_schemes = color_schemes,
  default_cursor_style = "BlinkingBlock",
  audible_bell = "Disabled",
  font_size = font_size,
  ratelimit_output_bytes_per_second = 4289999998,
  window_frame = { font_size = tab_font_size, }
}
