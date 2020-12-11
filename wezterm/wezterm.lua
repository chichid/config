local wezterm = require 'wezterm';

local mouse_bindings = {
  -- Right click sends "woot" to the terminal
  {
    event={Down={streak=1, button="Right"}},
    mods="NONE",
    action="PASTE"
  },
};

local keys = {
  -- Open the config
  { key=",", mods="ALT", action=wezterm.action{SendString="vim ~/.config/wezterm/wezterm.lua\r\n"}},
};

return {
  -- Key Bindings
  keys = keys,  
  mouse_bindings = mouse_bindings,
  
  -- shell 
  default_prog = {"wsl.exe"},

  -- Window size
  initial_rows = 45,
  initial_cols = 150,
  window_padding = {
    left = 1,
    right = 1,
    top = 1,
    bottom = 0,
  },

  -- color theme
  color_scheme = "ayu",

  colors = {
    tabbar = {
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
  },
 
  -- set to true to hide the tab bar when there is only
  -- a single tab in the window
  hide_tab_bar_if_only_one_tab = true,

  -- Font
  font = wezterm.font("Consolas"),
  font_size = 11.5,
  dpi = 96.0,
  font_antialias = "Subpixel", -- None, Greyscale, Subpixel
  font_hinting = "Full",  -- None, Vertical, VerticalSubpixel, Full

  -- How many lines of scrollback you want to retain per tab
  scrollback_lines = 3500,

  -- What to set the TERM variable to
  term = "xterm-256color",

  -- Constrains the rate at which output from a child command is
  -- processed and applied to the terminal model.
  -- This acts as a brake in the case of a command spewing a
  -- ton of output and allows for the UI to remain responsive
  -- so that you can hit CTRL-C to interrupt it if desired.
  -- The default value is 400,000 bytes/s.
  ratelimit_output_bytes_per_second = 400000,

  -- This helps to avoid saturating the link between the client
  -- and server.
  -- Each time the screen is updated as a result of the child
  -- command outputting data (rather than in response to input
  -- from the client), the server considers whether to push
  -- the result to the client.
  -- That decision is throttled by this configuration value
  -- which has a default value of 10/s
  ratelimit_mux_output_pushes_per_second = 10,

  -- Constrain how often the mux server scans the terminal
  -- model to compute a diff to send to the mux client.
  -- The default value is 100/s
  ratelimit_mux_output_scans_per_second = 100,

  -- Specifies how often a blinking cursor transitions between visible
  -- and invisible, expressed in milliseconds.
  -- Setting this to 0 disables blinking.
  -- Note that this value is approximate due to the way that the system
  -- event loop schedulers manage timers; non-zero values will be at
  -- least the interval specified with some degree of slop.
  -- It is recommended to avoid blinking cursors when on battery power,
  -- as it is relatively costly to keep re-rendering for the blink!
  cursor_blink_rate = 300,

  -- Specifies the default cursor style.  various escape sequences
  -- can override the default style in different situations (eg:
  -- an editor can change it depending on the mode), but this value
  -- controls how the cursor appears when it is reset to default.
  -- The default is `SteadyBlock`.
  -- Acceptable values are `SteadyBlock`, `BlinkingBlock`,
  -- `SteadyUnderline`, `BlinkingUnderline`, `SteadyBar`,
  -- and `BlinkingBar`.
  default_cursor_style = "BlinkingBlock",
}
