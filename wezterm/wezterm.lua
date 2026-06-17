local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- =========================================================
-- COLOR SCHEME
-- Random from favorites list (yours)
-- =========================================================
local favorites = {
	"Aardvark Blue",
}
math.randomseed(os.time())
config.color_scheme = favorites[math.random(#favorites)]

-- =========================================================
-- FONT (yours)
-- =========================================================
config.font = wezterm.font("FiraCode Nerd Font", { weight = "Regular" })
config.font_size = 16.0

-- =========================================================
-- WINDOW SIZE (yours)
-- =========================================================
config.initial_cols = 100
config.initial_rows = 27

-- =========================================================
-- WINDOW APPEARANCE
-- =========================================================
-- DUPLICATE window_decorations: mine adds borderless resize handle
config.window_decorations = "RESIZE"
config.window_padding = {
	left = 12,
	right = 12,
	top = 8,
	bottom = 8,
}
-- Yours had this commented out; keeping it commented. Uncomment to enable.
-- config.window_background_opacity = 0.9
config.macos_window_background_blur = 20 -- only applies on macOS

-- Window frame title bar bg (yours)
config.window_frame = {
	active_titlebar_bg = "#333333",
}

-- =========================================================
-- TAB BAR - General (mine — tab/window related, priority mine)
-- =========================================================
config.enable_tab_bar = true
config.use_fancy_tab_bar = false -- must be false for full custom styling
config.tab_bar_at_bottom = false
config.hide_tab_bar_if_only_one_tab = false
config.tab_max_width = 32
config.show_new_tab_button_in_tab_bar = true

-- =========================================================
-- TAB BAR - Rounded / Bubbly Colors (mine — tab/window related, priority mine)
-- =========================================================
local tab_bg = "#0d1b2a" -- overall bar background
local active_bg = "#1e90ff" -- active tab fill (bright blue)
local active_fg = "#ffffff" -- active tab text
local inactive_bg = "#1a2a3a" -- inactive tab fill
local inactive_fg = "#7aa3cc" -- inactive tab text
local hover_bg = "#2a4a6a" -- hovered inactive tab
local new_btn_fg = "#7aa3cc" -- + button color

-- =========================================================
-- COLORS - merged (tab_bar = mine; rest = yours)
-- =========================================================
config.colors = {
	-- Cursor (yours)
	cursor_bg = "#47FF9C",
	cursor_border = "#47FF9C",

	-- Selection (yours)
	selection_fg = "black",
	selection_bg = "#fffacd",

	-- Scrollbar & split (yours)
	scrollbar_thumb = "#222222",
	split = "#444444",

	-- ANSI colors (yours)
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

	-- Bright colors (yours)
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

	-- Tab bar colors (mine — tab/window related, priority mine)
	tab_bar = {
		background = tab_bg,

		active_tab = {
			bg_color = active_bg,
			fg_color = active_fg,
			intensity = "Bold",
			underline = "None",
			italic = false,
			strikethrough = false,
		},

		inactive_tab = {
			bg_color = inactive_bg,
			fg_color = inactive_fg,
		},

		inactive_tab_hover = {
			bg_color = hover_bg,
			fg_color = active_fg,
			italic = false,
		},

		new_tab = {
			bg_color = tab_bg,
			fg_color = new_btn_fg,
		},

		new_tab_hover = {
			bg_color = hover_bg,
			fg_color = active_fg,
		},
	},
}

-- =========================================================
-- TAB BAR - Rounded / Bubbly Shape (mine — tab/window related, priority mine)
-- Uses left pill  and right pill  Nerd Font chars
-- =========================================================
local LEFT_PILL = utf8.char(0xe0b6) --
local RIGHT_PILL = utf8.char(0xe0b4) --

wezterm.on("format-tab-title", function(tab, tabs, panes, cfg, hover, max_width)
	local is_active = tab.is_active

	local bg = is_active and active_bg or (hover and hover_bg or inactive_bg)
	local fg = is_active and active_fg or (hover and active_fg or inactive_fg)
	local edge = is_active and active_bg or (hover and hover_bg or inactive_bg)

	-- Use tab's user-set title if available, else fallback to tab index
	local title = tab.tab_title
	if not title or #title == 0 then
		title = "Tab " .. (tab.tab_index + 1)
	end

	-- Trim to fit max width
	if #title > max_width - 4 then
		title = wezterm.truncate_right(title, max_width - 4) .. "…"
	end

	return {
		{ Background = { Color = tab_bg } },
		{ Foreground = { Color = edge } },
		{ Text = LEFT_PILL },
		{ Background = { Color = bg } },
		{ Foreground = { Color = fg } },
		{ Attribute = { Intensity = is_active and "Bold" or "Normal" } },
		{ Text = " " .. title .. " " },
		{ Background = { Color = tab_bg } },
		{ Foreground = { Color = edge } },
		{ Text = RIGHT_PILL },
	}
end)

-- =========================================================
-- WINDOW TITLE BAR (mine — tab/window related, priority mine)
-- =========================================================
wezterm.on("format-window-title", function(tab, pane, tabs, panes, cfg)
	local title = tab.tab_title
	if not title or #title == 0 then
		title = tab.active_pane.title
	end
	return "WezTerm  " .. title
end)

-- =========================================================
-- KEY BINDINGS (mine — tab/window related, priority mine)
-- CTRL+SHIFT+T → prompt to rename current tab
-- =========================================================
config.keys = {
	{
		key = "t",
		mods = "CTRL|SHIFT",
		action = wezterm.action.PromptInputLine({
			description = "Enter a name for this tab:",
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
}

-- =========================================================
-- MISC
-- =========================================================
config.audible_bell = "Disabled"
config.scrollback_lines = 10000
config.default_cursor_style = "BlinkingBar"

return config
