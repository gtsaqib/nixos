---@diagnostic disable-next-line: unresolved-require
local noctalia = require 'noctalia'
-- local colors = noctalia.colors

hl.monitor {
  output = '',
  -- mode = '2048x1152@60.00800',
  mode = '1920x1080@60.00800',
  position = 'auto',
  scale = '1',
}

hl.config {
  general = {
    gaps_in = 5,
    gaps_out = 10,
    border_size = 0,

    resize_on_border = false,
    allow_tearing = false,
    layout = 'dwindle',
  },

  decoration = {
    rounding = 20,
    rounding_power = 2,
    active_opacity = 0.9,
    inactive_opacity = 0.8,

    shadow = {
      enabled = true,
      range = 4,
      render_power = 3,
      color = '#1a1a1aee',
    },

    blur = {
      enabled = true,
      passes = 4,
      size = 14,

      contrast = 1,
      brightness = 0.88,
      vibrancy_darkness = 0.19,

      popups = true,
      popups_ignorealpha = 0.1,
    },

    -- glow = {
    --   enabled = true,
    --   range = 35,
    --   render_power = 3,
    --   color = colors.surface,
    --   color_inactive = '#00000000'
    -- }
  },

  dwindle = { preserve_split = true },

  master = { new_status = 'master' },

  scrolling = { fullscreen_on_one_column = true },

  misc = {
    force_default_wallpaper = 0,
    disable_hyprland_logo = true,
    disable_splash_rendering = true,
    focus_on_activate = true,
  },

  input = {
    kb_layout = 'us',
    kb_variant = '',
    kb_model = '',
    kb_options = '',
    kb_rules = '',

    repeat_rate = 60,
    repeat_delay = 250,

    follow_mouse = 1,
    sensitivity = 0,

    scroll_method = 'on_button_down',
    scroll_button = 274,
    scroll_factor = 1.7,

    touchpad = { natural_scroll = false },
  },
}

hl.gesture {
  fingers = 3,
  direction = 'horizontal',
  action = 'workspace',
}

noctalia.apply_theme()

hl.window_rule {
  name = 'fix-xwayland-drags',
  match = {
    class = '^$',
    title = '^$',
    xwayland = true,
    float = true,
    fullscreen = false,
    pin = false,
  },
  no_focus = true,
}

hl.window_rule {
  name = 'float-dialogs',
  match = {
    class = 'dev\\.noctalia\\.Noctalia|xdg-desktop-portal-gtk|org\\.gnome\\.Loupe|com\\.github\\.rafostar\\.Clapper',
  },
  size = { 1080, 920 },
  float = true,
  center = true,
}

hl.window_rule {
  name = 'remove-terminal-border',
  match = { class = 'kitty' },
  border_size = 0,
}

hl.window_rule {
  name = 'dim-terminal',
  match = { class = 'kitty' },
  opacity = '0.85 1',
}

hl.layer_rule {
  name = 'noctalia',
  match = {
    namespace = '^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd|window-switcher)$',
  },
  no_anim = true,
  ignore_alpha = 0.1,
  blur = true,
}

hl.workspace_rule { workspace = '1', persistent = true }
hl.workspace_rule { workspace = '2', persistent = true }
hl.workspace_rule { workspace = '3', persistent = true }
hl.workspace_rule { workspace = '4', persistent = true }
hl.workspace_rule { workspace = '5', persistent = true }

require 'animation'
require 'binds'
require 'plugins'
