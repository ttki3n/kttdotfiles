local wezterm = require 'wezterm'

local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- Font settings
config.font_size = 13
--config.line_height = 1.0
config.font = wezterm.font('JetBrains Mono')
config.color_scheme = 'Catppuccin Mocha'

-- Appearance
config.cursor_blink_rate = 0
config.window_decorations = 'RESIZE'
--config.enable_tab_bar = false
--config.hide_tab_bar_if_only_one_tab = true
config.adjust_window_size_when_changing_font_size = false

config.initial_cols = 120
config.initial_rows = 30
config.macos_window_background_blur = 30
config.window_background_opacity = 1.0

-- Miscellaneous settings
--config.max_fps = 120
--config.prefer_egl = true

---[ LEADER KEY
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 5000 }

---[ BASE KEYBINDINGS
local act = wezterm.action
config.keys = {
  -- Send Ctrl+a to terminal when pressed twice
  { key = "a",  mods = "LEADER|CTRL", action = act.SendString("\x01") },

  -- Mode trigger
  { key = 'r',   mods = 'LEADER', action = act.ActivateKeyTable { name = 'resize_panel', one_shot = false } },
  { key = 'Tab', mods = 'LEADER', action = act.ActivateKeyTable { name = 'workspace_mode', one_shot = true } },

  -- Flat binding
  --{ key = "-",  mods = "LEADER", action = act.SplitVertical { domain = "CurrentPaneDomain" } },
  --{ key = "\\", mods = "LEADER", action = act.SplitHorizontal { domain = "CurrentPaneDomain" } },
  { key = "s",  mods = "LEADER", action = act.SplitVertical { domain = "CurrentPaneDomain" } },
  { key = "v",  mods = "LEADER", action = act.SplitHorizontal { domain = "CurrentPaneDomain" } },
  { key = "o",  mods = "LEADER", action = act.TogglePaneZoomState },
  { key = "z",  mods = "LEADER", action = act.TogglePaneZoomState },
  { key = "c",  mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
  { key = "n",  mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },

  -- Navigation
  { key = "h",  mods = "LEADER", action = act.ActivatePaneDirection("Left") },
  { key = "j",  mods = "LEADER", action = act.ActivatePaneDirection("Down") },
  { key = "k",  mods = "LEADER", action = act.ActivatePaneDirection("Up") },
  { key = "l",  mods = "LEADER", action = act.ActivatePaneDirection("Right") },

  -- Resizing
  --{ key = "LeftArrow",  mods = "LEADER|SHIFT", action = act.AdjustPaneSize { "Left", 5 } },
  { key = "LeftArrow",  mods = "LEADER", action = act.AdjustPaneSize { "Left", 5 } },
  { key = "DownArrow",  mods = "LEADER", action = act.AdjustPaneSize { "Down", 5 } },
  { key = "UpArrow",  mods = "LEADER", action = act.AdjustPaneSize { "Up", 5 } },
  { key = "RightArrow",  mods = "LEADER", action = act.AdjustPaneSize { "Right", 5 } },

  -- Tab Navigation (1-9)
  { key = "1",  mods = "LEADER", action = act.ActivateTab(0) },
  { key = "2",  mods = "LEADER", action = act.ActivateTab(1) },
  { key = "3",  mods = "LEADER", action = act.ActivateTab(2) },
  { key = "4",  mods = "LEADER", action = act.ActivateTab(3) },
  { key = "5",  mods = "LEADER", action = act.ActivateTab(4) },
  { key = "6",  mods = "LEADER", action = act.ActivateTab(5) },
  { key = "7",  mods = "LEADER", action = act.ActivateTab(6) },
  { key = "8",  mods = "LEADER", action = act.ActivateTab(7) },
  { key = "9",  mods = "LEADER", action = act.ActivateTab(8) },

  -- Closing
  { key = "&",  mods = "LEADER|SHIFT", action = act.CloseCurrentTab { confirm = true } },
  { key = "d",  mods = "LEADER", action = act.CloseCurrentPane { confirm = true } },
  { key = "x",  mods = "LEADER", action = act.CloseCurrentPane { confirm = true } },
}

---[ Key Tables
-- Show which key table is active in the status area
wezterm.on('update-right-status', function(window, pane)
  local name = window:active_key_table()
  if name then
    name = 'TABLE: ' .. name
  end
  window:set_right_status(name or '')
end)
config.key_tables = {

  resize_panel = {
    { key = 'LeftArrow', action = act.AdjustPaneSize { 'Left', 5 } },
    { key = 'h', action = act.AdjustPaneSize { 'Left', 5 } },

    { key = 'RightArrow', action = act.AdjustPaneSize { 'Right', 5 } },
    { key = 'l', action = act.AdjustPaneSize { 'Right', 5 } },

    { key = 'UpArrow', action = act.AdjustPaneSize { 'Up', 5 } },
    { key = 'k', action = act.AdjustPaneSize { 'Up', 5 } },

    { key = 'DownArrow', action = act.AdjustPaneSize { 'Down', 5 } },
    { key = 'j', action = act.AdjustPaneSize { 'Down', 5 } },

    -- Cancel the mode by pressing escape
    { key = 'Escape', action = 'PopKeyTable' },
  },

  -- Triggered by <leader> w
  window_mode = {
    { key = 'v', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    { key = 's', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
    { key = 'h', action = act.ActivatePaneDirection('Left') },
    { key = 'j', action = act.ActivatePaneDirection('Down') },
    { key = 'k', action = act.ActivatePaneDirection('Up') },
    { key = 'l', action = act.ActivatePaneDirection('Right') },
    { key = 'q', action = act.CloseCurrentPane { confirm = true } },
    { key = 'c', action = act.CloseCurrentPane { confirm = true } },
    { key = 'H', action = act.AdjustPaneSize { 'Left', 5 } },
    { key = 'J', action = act.AdjustPaneSize { 'Down', 5 } },
    { key = 'K', action = act.AdjustPaneSize { 'Up', 5 } },
    { key = 'RightArrow', action = act.AdjustPaneSize { 'Right', 5 } },
    { key = 'Escape', action = 'PopKeyTable' },
  },

  -- Triggered by <leader> Tab
  workspace_mode = {
    { key = 'n', action = act.SpawnTab('CurrentPaneDomain') },
    { key = 'd', action = act.CloseCurrentTab { confirm = true } },
    { key = '[', action = act.ActivateTabRelative(-1) },
    { key = ']', action = act.ActivateTabRelative(1) },
    { key = 'Escape', action = 'PopKeyTable' },
  },
}

return config

