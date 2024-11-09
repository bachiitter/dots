-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Font
config.font = wezterm.font_with_fallback({
	{ family = "BlexMono Nerd Font", weight = "Medium" },
})

config.font_size = 11.5
config.line_height = 1.5
config.cell_width = 1
config.custom_block_glyphs = false

-- Color Scheme
config.color_scheme = "Catppuccin Mocha"

-- Window
-- config.window_decorations = "NONE"
config.window_padding = {
	left = 2,
	right = 2,
	top = 2,
	bottom = 2,
}

-- Tab bar
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.show_new_tab_button_in_tab_bar = false

-- and finally, return the configuration to wezterm
return config
