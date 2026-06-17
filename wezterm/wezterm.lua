-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Custom colors
config = {
	default_cursor_style = "BlinkingBar",
}
config.window_frame = {
	active_titlebar_bg = "#333333",
}
config.colors = {
	cursor_bg = "#47FF9C",
	cursor_border = "#47FF9C",
	selection_fg = "black",
	selection_bg = "#fffacd",
	scrollbar_thumb = "#222222",
	split = "#444444",
	ansi = {
		"black",
		"maroon",
		"green",
		"olive",
		"navy",
		"purple",
		"teal",
		"silver",
	},
	brights = {
		"grey",
		"red",
		"lime",
		"yellow",
		"blue",
		"fuchsia",
		"aqua",
		"white",
	},

	tab_bar = {
		background = "#060022",

		active_tab = {
			bg_color = "#120035",
			fg_color = "#c0c0c0",
			intensity = "Normal",
			underline = "None",
			italic = false,
			strikethrough = false,
		},

		inactive_tab = {
			bg_color = "#1b1032",
			fg_color = "#808080",
		},

		inactive_tab_hover = {
			bg_color = "#3b3052",
			fg_color = "#909090",
			italic = true,
		},

		new_tab = {
			bg_color = "#944032",
			fg_color = "#808080",
		},

		new_tab_hover = {
			bg_color = "#3b3052",
			fg_color = "#909090",
			italic = true,
		},
	},
}

local favorites = {
	"Aardvark Blue",
}

math.randomseed(os.time())
config.color_scheme = favorites[math.random(#favorites)]
config.initial_cols = 100
config.initial_rows = 27
config.font_size = 17
--config.window_background_opacity = 0.9

return config
