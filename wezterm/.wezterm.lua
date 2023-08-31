-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

-- config.color_scheme = 'Zenburn
-- config.font = wezterm.font 'DejaVuSansMono Nerd Font'
config.font = wezterm.font 'Menlo'
config.font_size = 15
config.line_height = 1.2
config.hide_tab_bar_if_only_one_tab = true
-- config.dpi = 96.0

-- and finally, return the configuration to wezterm
return config

