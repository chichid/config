local wezterm = require 'wezterm';

local mouse_bindings = {
  -- Right Click to paste 
  { event={Down={streak=1, button="Right"}}, mods="NONE", action="Paste" },
};

local keys = {
  -- Copy/Paste 
  { key="c", mods="CTRL", action="Copy" },
  { key="c", mods="CMD", action="Copy" },
  { key="v", mods="CTRL", action="Paste" },
  { key="v", mods="CMD", action="Paste" },
  
  -- Open New Window 
  { key="t", mods="CMD", action=wezterm.action{SpawnTab="CurrentPaneDomain"} },
  { key="t", mods="ALT", action=wezterm.action{SpawnTab="CurrentPaneDomain"} },
  { key="n", mods="CMD", action="SpawnWindow" },
  { key="n", mods="ALT", action="SpawnWindow" },

  -- Open the config
  { key=",", mods="ALT", action=wezterm.action{SendString="vim ~/.config/wezterm/wezterm.lua\r\n"}},
  { key=",", mods="CMD", action=wezterm.action{SendString="vim ~/.config/wezterm/wezterm.lua\r\n"}},
};

local colors = {
  tab_bar = {
    background = "black",

    active_tab = {
      bg_color = "#111",
      fg_color = "white",
      intensity = "Bold",
    },

    inactive_tab = {
      bg_color = "black",
      fg_color = "#555",
    },

    inactive_tab_hover = {
      bg_color = "#222",
      fg_color = "#555",
    },
  },
};

return {
  -- Key Bindings
  keys = keys,  
  mouse_bindings = mouse_bindings,
  
  -- General 
  default_prog = {"wsl.exe"},
  hide_tab_bar_if_only_one_tab = true,
  term = "xterm-256color",

  -- Window
  initial_rows = 45,
  initial_cols = 150,
  window_padding = {
    left = 1,
    right = 1,
    top = 1,
    bottom = 0,
  },

  -- Theme
  default_cursor_style = "BlinkingBlock",
  cursor_blink_rate = 300,
  color_scheme = "ayu",
  colors = colors,
  font = wezterm.font("Consolas"),
  font_size = 11.5,
  dpi = 96.0,
  font_antialias = "Subpixel", -- None, Greyscale, Subpixel
  font_hinting = "Full",  -- None, Vertical, VerticalSubpixel, Full

  -- Fine Tuning
  scrollback_lines = 3500,
  ratelimit_output_bytes_per_second = 400000,
  ratelimit_mux_output_pushes_per_second = 10,
  ratelimit_mux_output_scans_per_second = 100,
}
