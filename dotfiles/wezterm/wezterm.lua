local wezterm = require 'wezterm'

local config = wezterm.config_builder()

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

return config

