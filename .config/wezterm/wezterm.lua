local wezterm = require("wezterm")
local config = {}

config.audible_bell = "Disabled"
config.window_close_confirmation = "NeverPrompt"
config.check_for_updates = false

-- config.color_scheme = "Dracula (Gogh)"
config.color_scheme = "Horizon Dark (Gogh)"
local background_color = wezterm.get_builtin_color_schemes()[config.color_scheme].background

config.font = wezterm.font("JetBrainsMono NF")
config.font_size = 13
config.harfbuzz_features = { "zero" } -- Slashed 0 in JetBrainsMono

config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.tab_max_width = 32
config.hide_tab_bar_if_only_one_tab = false

config.enable_scroll_bar = true

config.mouse_bindings = {
    -- Disable the default click behavior
    {
      event = { Up = { streak = 1, button = "Left"} },
      mods = "NONE",
      action = wezterm.action.DisableDefaultAssignment,
    },
    -- Ctrl-click will open the link under the mouse cursor
    {
        event = { Up = { streak = 1, button = "Left" } },
        mods = "CTRL",
        action = wezterm.action.OpenLinkAtMouseCursor,
    },
    -- Disable the Ctrl-click down event to stop programs from seeing it when a URL is clicked
    {
        event = { Down = { streak = 1, button = "Left" } },
        mods = "SHIFT",
        action = wezterm.action.Nop,
    },
}

config.colors = {
	tab_bar = {
		background = background_color,

		new_tab = {
			bg_color = background_color,
			fg_color = "#808080",
		},
		new_tab_hover = {
			bg_color = background_color,
			fg_color = "#808080",
		},
	},
	scrollbar_thumb = "#3b3052",
}

local action = wezterm.action
config.keys = {
	{
		key = "n",
		mods = "CTRL|SHIFT",
		action = action.SpawnTab("CurrentPaneDomain"),
	},
	{
		key = "w",
		mods = "CTRL|SHIFT",
		action = action.CloseCurrentPane({ confirm = true }),
	},
	-- Create new panes
	{
		key = "_",
		mods = "CTRL|SHIFT",
		action = action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "|",
		mods = "CTRL|SHIFT",
		action = action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	-- Rotate panes
	{
		key = "L",
		mods = "CTRL|SHIFT|ALT",
		action = action.RotatePanes("CounterClockwise"),
	},
	-- Move between tabs
	{
		key = "LeftArrow",
		mods = "CTRL|SHIFT",
		action = action.ActivateTabRelative(-1),
	},
	{
		key = "RightArrow",
		mods = "CTRL|SHIFT",
		action = action.ActivateTabRelative(1),
	},
	-- Move between panes
	{
		key = "}",
		mods = "CTRL|SHIFT",
		action = action.ActivatePaneDirection("Next"),
	},
	{
		key = "{",
		mods = "CTRL|SHIFT",
		action = action.ActivatePaneDirection("Prev"),
	},
	-- Resize panes
	{
		key = "H",
		mods = "CTRL|SHIFT",
		action = action.AdjustPaneSize({ "Left", 5 }),
	},
	{
		key = "J",
		mods = "CTRL|SHIFT",
		action = action.AdjustPaneSize({ "Down", 5 }),
	},
	{
		key = "K",
		mods = "CTRL|SHIFT",
		action = action.AdjustPaneSize({ "Up", 5 }),
	},
	{
		key = "L",
		mods = "CTRL|SHIFT",
		action = action.AdjustPaneSize({ "Right", 5 }),
	},
	-- Change tab order
	{
		key = "{",
		mods = "CTRL|SHIFT|ALT",
		action = action.MoveTabRelative(-1),
	},
	{
		key = "}",
		mods = "CTRL|SHIFT|ALT",
		action = action.MoveTabRelative(1),
	},
	{
		key = "r",
		mods = "CMD|SHIFT",
		action = action.PromptInputLine({
			description = "Enter new name for tab",
			action = wezterm.action_callback(function(window, _, line)
				-- line will be `nil` if they hit escape without entering anything
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
}

-- The filled in variant of the < symbol
local SOLID_LEFT_HALF_CIRCLE = wezterm.nerdfonts.ple_left_half_circle_thick

-- The filled in variant of the > symbol
local SOLID_RIGHT_LEFT_CIRCLE = wezterm.nerdfonts.ple_right_half_circle_thick

local function tab_title(tab_info)
	local title = tab_info.tab_title
	-- if the tab title is explicitly set, take that
	if title and #title > 0 then
		return title
	end
	-- Otherwise, use the title from the active pane
	-- in that tab
	return tab_info.active_pane.title
end

wezterm.on("format-tab-title", function(tab, _, _, _, hover, max_width)
	local edge_background = background_color
	local background = "#292a36"
	local foreground = "#808080"

	if tab.is_active then
		background = "#494259"
		foreground = "#c0c0c0"
	elseif hover then
		background = "#3b3052"
		foreground = "#909090"
	end

	local edge_foreground = background

	local title = tab_title(tab)

	-- ensure that the titles fit in the available space,
	-- and that we have room for the edges.
	title = wezterm.truncate_right(title, max_width - 2)

	return {
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = SOLID_LEFT_HALF_CIRCLE },
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Text = title },
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = SOLID_RIGHT_LEFT_CIRCLE },
	}
end)

return config
