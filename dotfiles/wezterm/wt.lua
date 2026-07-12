local wezterm = require 'wezterm'
local act = wezterm.action

local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.color_scheme = 'Catppuccin Mocha'
config.colors = {
  tab_bar = {
    -- The background color of the tab bar itself
    background = '#1e1e2e',
  },
}
---[ Tab styling
wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
  local edge_background = '#1e1e2e'
  local background = '#313244'
  local foreground = '#cdd6f4'

  if tab.is_active then
    background = '#cba6f7'
    foreground = '#11111b'
  elseif hover then
    background = '#585b70'
    foreground = '#cdd6f4'
  end

  -- The trick: determine the background color of the NEXT tab.
  -- This allows the curve of the current tab to blend seamlessly
  -- into the background of the tab that follows it.
  local next_background = edge_background
  if tab.tab_index < #tabs - 1 then
    -- Lua arrays are 1-indexed, while tab.tab_index is 0-indexed
    local next_tab = tabs[tab.tab_index + 2]
    if next_tab.is_active then
      next_background = '#cba6f7'
    else
      next_background = '#313244'
    end
  end

  local title = tab.active_pane.title
  if string.len(title) > 20 then
    title = string.sub(title, 1, 17) .. "..."
  end
  title = string.format(' %s ', title)

  local elements = {}

  -- 1. Add a rounded left edge ONLY to the very first tab
  if tab.tab_index == 0 then
    table.insert(elements, { Background = { Color = edge_background } })
    table.insert(elements, { Foreground = { Color = background } })
    table.insert(elements, { Text = '' }) -- U+E0B6
  end

  -- 2. The main body of the tab
  table.insert(elements, { Background = { Color = background } })
  table.insert(elements, { Foreground = { Color = foreground } })
  table.insert(elements, { Text = title })

  -- 3. The right curved edge, which blends into the NEXT tab's background
  table.insert(elements, { Background = { Color = next_background } })
  table.insert(elements, { Foreground = { Color = background } })
  table.insert(elements, { Text = '' }) -- U+E0B4

  return elements
end)

---[ UI & APPEARANCE
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = true
config.window_decorations = "NONE"
config.show_new_tab_button_in_tab_bar = false

config.font = wezterm.font_with_fallback {
  { family = "Iosevka Nerd Font Mono", weight = "Medium" },
  "Symbols Nerd Font Mono",
  "icons-in-terminal",
  "Material Icons",
}
config.font_size = 14.0

---[ LEADER KEY
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 2000 }

---[ BASE KEYBINDINGS
config.keys = {
  -- Send Ctrl+a to terminal when pressed twice
  { key = "a",  mods = "LEADER|CTRL", action = act.SendString("\x01") },

  -- Doom Mode trigger
  { key = 'w',   mods = 'LEADER', action = act.ActivateKeyTable { name = 'window_mode', one_shot = true } },
  { key = 'Tab', mods = 'LEADER', action = act.ActivateKeyTable { name = 'workspace_mode', one_shot = true } },

  -- Flat binding
  { key = "-",  mods = "LEADER", action = act.SplitVertical { domain = "CurrentPaneDomain" } },
  { key = "\\", mods = "LEADER", action = act.SplitHorizontal { domain = "CurrentPaneDomain" } },
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
  { key = "H",  mods = "LEADER|SHIFT", action = act.AdjustPaneSize { "Left", 5 } },
  { key = "J",  mods = "LEADER|SHIFT", action = act.AdjustPaneSize { "Down", 5 } },
  { key = "K",  mods = "LEADER|SHIFT", action = act.AdjustPaneSize { "Up", 5 } },
  { key = "L",  mods = "LEADER|SHIFT", action = act.AdjustPaneSize { "Right", 5 } },

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
config.key_tables = {

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
    { key = 'L', action = act.AdjustPaneSize { 'Right', 5 } },
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