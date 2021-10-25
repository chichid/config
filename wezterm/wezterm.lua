local wezterm = require 'wezterm';
 
local default_prog;
local font_size;
local dpi;
local initial_rows;
local initial_cols;

if string.find(wezterm.target_triple, "windows") then
  default_prog = {"wsl", "~"}; 
  font_size = 10.5;
  initial_rows = 44;
  initial_cols = 140;
end

if string.find(wezterm.target_triple, "darwin") then
  font_size = 13.5;
  initial_rows = 20;
  initial_cols = 100;
end

local mouse_bindings = {
  -- Right Click to paste 
  { event={Down={streak=1, button="Right"}}, mods="NONE", action="Paste" },
};

wezterm.on("SpawnNewWindowInWorkingDirectory", function(window, pane)
  current_directory = pane:get_current_working_dir():gsub("file://dox", "")
  startup_command = "export wezterm_startup_directory=" .. current_directory .. "&& fish"

  -- Open a new window running vim and tell it to open the file
  window:perform_action(wezterm.action{SpawnCommandInNewWindow={
    args={"bash", "-c", startup_command}
  }}, pane)
end)

wezterm.on("SpawnNewTabInWorkingDirectory", function(window, pane)
  current_directory = pane:get_current_working_dir():gsub("file://dox", "")
  startup_command = "export wezterm_startup_directory=" .. current_directory .. "&& fish"

  -- Open a new window running vim and tell it to open the file
  window:perform_action(wezterm.action{SpawnCommandInNewTab={
    args={"bash", "-c", startup_command}
  }}, pane)
end)

local keys = {
  -- Clear Screen
  { key="k", mods="ALT", action=wezterm.action{SendString="printf '\\033c'\n"}},
  { key="k", mods="CMD", action=wezterm.action{SendString="printf '\\033c'\n"}},
  
  -- Copy/Paste 
  { key="c", mods="ALT", action="Copy" },
  { key="c", mods="CMD", action="Copy" },
  { key="v", mods="ALT", action="Paste" },
  { key="v", mods="CMD", action="Paste" },
  
  -- Open New Window 
  { key="t", mods="CMD", action=wezterm.action{SpawnTab="CurrentPaneDomain"} },
  { key="t", mods="ALT", action=wezterm.action{EmitEvent="SpawnNewTabInWorkingDirectory"} },
  { key="n", mods="CMD", action="SpawnWindow" },
  { key="n", mods="ALT", action=wezterm.action{EmitEvent="SpawnNewWindowInWorkingDirectory"}},

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
  ["ayu_dark"] = {
    -- Ayu Dark
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
  -- General
  window_close_confirmation = "NeverPrompt",

  set_environment_variables = {
    -- This changes the default prompt for cmd.exe to report the current directory using OSC 7, show the current time and
    prompt = "$E]7;file://localhost/$P$E\\$E[32m$T$E[0m $E[35m$P$E[36m$_$G$E[0m ",
  },


  -- Key Bindings
  keys = keys,  
  mouse_bindings = mouse_bindings,
  
  -- General 
  default_prog = default_prog,
  hide_tab_bar_if_only_one_tab = true,
  term = "xterm-256color",

  -- Window
  initial_rows = 44,
  initial_cols = 140,
  window_padding = {
    left = 1,
    right = 1,
    top = 1,
    bottom = 0,
  },

  -- Appearance and Colors 
  color_schemes = color_schemes,
  color_scheme = "ayu_dark" ,
  colors = colors,
  default_cursor_style = "BlinkingBlock",
  cursor_blink_rate = 400,
  font = wezterm.font("Fira Code"),
  font_size = font_size,
  dpi = dpi,
  -- font_antialias = "Subpixel", -- None, Greyscale, Subpixel
  -- font_hinting = "Full",  -- None, Vertical, VerticalSubpixel, Full

  -- Fine Tuning
  scrollback_lines = 3500,
  -- ratelimit_output_bytes_per_second = 400000,
  -- ratelimit_mux_output_pushes_per_second = 10,
  -- ratelimit_mux_output_scans_per_second = 100,
}
