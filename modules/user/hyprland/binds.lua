local mod = 'SUPER'
local ipc = 'noctalia msg'

local terminal = 'uwsm app -- kitty'
local file_manager = 'uwsm app -- xdg-open ~'
local web_browser = 'uwsm app -- xdg-open http://'

---@param direction 'l'|'r'
---@return fun() dispatcher
local function focus_group_aware(direction)
  return function()
    local window = hl.get_active_window()

    if window and window.group then
      hl.dispatch(direction == 'l' and hl.dsp.group.prev() or hl.dsp.group.prev())
    else
      hl.dispatch(hl.dsp.focus { direction = direction })
    end
  end
end

local is_game_mode_enabled = false
local is_no_blur_enabled = false
local is_no_gaps_enabled = false
local is_no_animation_enabled = false

---@type boolean?
local previous_blur_enabled

---@type table?
local previous_gaps_config

---@type boolean?
local previous_animations_enabled

local function game_mode_toggle()
  if is_game_mode_enabled then
    hl.exec_cmd 'hyprctl reload'
    hl.exec_cmd(('%s bar-show primary'):format(ipc))

    is_game_mode_enabled = false
    is_no_blur_enabled = false
    is_no_gaps_enabled = false
    is_no_animation_enabled = false

    previous_blur_enabled = nil
    previous_gaps_config = nil
    previous_animations_enabled = nil
    return
  end

  hl.config {
    general = {
      gaps_in = 0,
      gaps_out = 0,
      border_size = 0,
    },
    decoration = {
      shadow = { enabled = false },
      blur = { enabled = false },
      rounding = 0,
    },
    animations = { enabled = false },
  }

  hl.exec_cmd(('%s bar-hide primary'):format(ipc))
  is_game_mode_enabled = true
end

local function blur_toggle()
  if is_game_mode_enabled then
    return
  end

  if is_no_blur_enabled then
    if previous_blur_enabled ~= nil then
      hl.config {
        decoration = {
          blur = { enabled = previous_blur_enabled },
        },
      }
    end

    previous_blur_enabled = nil
    is_no_blur_enabled = false
    return
  end

  previous_blur_enabled = hl.get_config 'decoration.blur.enabled'

  hl.config {
    decoration = {
      blur = { enabled = false },
    },
  }

  is_no_blur_enabled = true
end

local function gaps_toggle()
  if is_game_mode_enabled then
    return
  end

  if is_no_gaps_enabled then
    if previous_gaps_config then
      hl.config {
        general = {
          gaps_in = previous_gaps_config.gaps_in,
          gaps_out = previous_gaps_config.gaps_out,
        },
        decoration = {
          shadow = { enabled = previous_gaps_config.shadow_enabled },
          rounding = previous_gaps_config.rounding,
        },
      }
    end

    previous_gaps_config = nil
    is_no_gaps_enabled = false
    return
  end

  previous_gaps_config = {
    gaps_in = hl.get_config 'general.gaps_in',
    gaps_out = hl.get_config 'general.gaps_out',
    shadow_enabled = hl.get_config 'decoration.shadow.enabled',
    rounding = hl.get_config 'decoration.rounding',
  }

  hl.config {
    general = {
      gaps_in = 0,
      gaps_out = 0,
    },
    decoration = {
      shadow = { enabled = false },
      rounding = 0,
    },
  }

  is_no_gaps_enabled = true
end

local function animation_toggle()
  if is_game_mode_enabled then
    return
  end

  if is_no_animation_enabled then
    if previous_animations_enabled ~= nil then
      hl.config {
        animations = {
          enabled = previous_animations_enabled,
        },
      }
    end

    previous_animations_enabled = nil
    is_no_animation_enabled = false
    return
  end

  previous_animations_enabled = hl.get_config 'animations.enabled'

  hl.config {
    animations = { enabled = false },
  }

  is_no_animation_enabled = true
end

---@alias HL.Layout 'dwindle'|'master'|'scrolling'|'monocle'

local function layout_toggle()
  ---@type HL.Layout[]
  local layouts = { 'dwindle', 'master', 'scrolling', 'monocle' }
  local workspace = hl.get_active_workspace()
  ---@type HL.Layout?
  local layout = 'dwindle'

  if hl.get_active_special_workspace() then
    workspace = hl.get_active_special_workspace()
  end
  if not workspace then
    return
  end

  for i = 1, #layouts do
    if layouts[i] == workspace.tiled_layout then
      local next_layout_idx = (i % #layouts) + 1
      layout = layouts[next_layout_idx]
      break
    end
  end

  if workspace.special then
    hl.workspace_rule { workspace = tostring(workspace.name), layout = layout }
  else
    hl.workspace_rule { workspace = tostring(workspace.id), layout = layout }
  end
end

---@param binds table<HL.Layout, HL.Dispatcher>
---@return fun() dispatcher
local function layout_bind(binds)
  return function()
    local workspace = hl.get_active_special_workspace() or hl.get_active_workspace()

    if not workspace then
      return
    end

    local layout = workspace.tiled_layout
    ---@cast layout HL.Layout

    hl.dispatch(binds[layout])
  end
end

local min_zoom = 1
local max_zoom = 4.5
local zoom_toggle_factor = 2

---@param offset number?
local function zoom(offset)
  local current = hl.get_config 'cursor.zoom_factor'
  if offset ~= nil then
    current = current + offset
  elseif current ~= min_zoom then
    current = min_zoom
  else
    current = zoom_toggle_factor
  end

  hl.config {
    cursor = {
      zoom_factor = math.max(min_zoom, math.min(max_zoom, current)),
    },
  }
end

hl.bind(mod .. ' + Return', hl.dsp.exec_cmd(terminal), { description = 'Open terminal' })
hl.bind(mod .. ' + E', hl.dsp.exec_cmd(file_manager), { description = 'Open file manager' })
hl.bind(mod .. ' + B', hl.dsp.exec_cmd(web_browser), { description = 'Open web browser' })

hl.bind(
  mod .. ' + H',
  focus_group_aware 'l',
  { repeating = true, description = 'Focus window left or previous group window' }
)
hl.bind(
  mod .. ' + J',
  hl.dsp.focus { direction = 'd' },
  { repeating = true, description = 'Focus window down' }
)
hl.bind(
  mod .. ' + K',
  hl.dsp.focus { direction = 'u' },
  { repeating = true, description = 'Focus window up' }
)
hl.bind(
  mod .. ' + L',
  focus_group_aware 'r',
  { repeating = true, description = 'Focus window right or next group window' }
)
hl.bind(
  mod .. ' + SHIFT + H',
  hl.dsp.window.move { direction = 'l', group_aware = true },
  { repeating = true, description = 'Move window left' }
)
hl.bind(
  mod .. ' + SHIFT + J',
  hl.dsp.window.move { direction = 'd', group_aware = true },
  { repeating = true, description = 'Move window down' }
)
hl.bind(
  mod .. ' + SHIFT + K',
  hl.dsp.window.move { direction = 'u', group_aware = true },
  { repeating = true, description = 'Move window up' }
)
hl.bind(
  mod .. ' + SHIFT + L',
  hl.dsp.window.move { direction = 'r', group_aware = true },
  { repeating = true, description = 'Move window right' }
)
hl.bind(
  mod .. ' + CTRL + H',
  hl.dsp.window.resize { x = -10, y = 0, relative = true },
  { repeating = true, description = 'Shrink window width' }
)
hl.bind(
  mod .. ' + CTRL + J',
  hl.dsp.window.resize { x = 0, y = 10, relative = true },
  { repeating = true, description = 'Grow window height' }
)
hl.bind(
  mod .. ' + CTRL + K',
  hl.dsp.window.resize { x = 0, y = -10, relative = true },
  { repeating = true, description = 'Shrink window height' }
)
hl.bind(
  mod .. ' + CTRL + L',
  hl.dsp.window.resize { x = 10, y = 0, relative = true },
  { repeating = true, description = 'Grow window width' }
)
hl.bind(mod .. ' + mouse:272', hl.dsp.window.drag(), { mouse = true, description = 'Drag window' })
hl.bind(
  mod .. ' + mouse:273',
  hl.dsp.window.resize(),
  { mouse = true, description = 'Resize window' }
)

hl.bind(mod .. ' + Q', hl.dsp.window.close(), { description = 'Close window' })
hl.bind(mod .. ' + Delete', hl.dsp.window.kill(), { description = 'Kill window' })
hl.bind(mod .. ' + Space', hl.dsp.window.float(), { description = 'Toggle float' })
hl.bind(mod .. ' + F', hl.dsp.window.fullscreen(), { description = 'Toggle fullscreen' })
hl.bind(
  mod .. ' + SHIFT + F',
  hl.dsp.window.fullscreen_state { internal = 2, client = 0 },
  { description = 'Fullscreen (Hyprland only)' }
)
hl.bind(
  mod .. ' + CTRL + F',
  hl.dsp.window.fullscreen_state { internal = 0, client = 2 },
  { description = 'Fullscreen (client only)' }
)
hl.bind(mod .. ' + P', hl.dsp.window.pseudo(), { description = 'Toggle pseudo' })
hl.bind(mod .. ' + C', hl.dsp.window.center(), { description = 'Center window' })
hl.bind(mod .. ' + Y', hl.dsp.window.pin(), { description = 'Pin window' })
hl.bind(mod .. ' + G', hl.dsp.group.toggle(), { description = 'Toggle group' })
hl.bind(
  'ALT + Tab',
  hl.dsp.exec_cmd(ipc .. ' window-switcher hold'),
  { repeating = true, description = 'Switch window' }
)

hl.bind(
  mod .. ' + U',
  hl.dsp.focus { workspace = 'e-1', on_current_monitor = true },
  { repeating = true, description = 'Focus previous workspace' }
)
hl.bind(
  mod .. ' + D',
  hl.dsp.focus { workspace = 'e+1', on_current_monitor = true },
  { repeating = true, description = 'Focus next workspace' }
)
hl.bind(
  mod .. ' + SHIFT + U',
  hl.dsp.window.move { workspace = 'e-1', on_current_monitor = true },
  { repeating = true, description = 'Move window to previous workspace' }
)
hl.bind(
  mod .. ' + SHIFT + D',
  hl.dsp.window.move { workspace = 'e+1', on_current_monitor = true },
  { repeating = true, description = 'Move window to next workspace' }
)
hl.bind(
  mod .. ' + mouse_up',
  hl.dsp.focus { workspace = '-1', on_current_monitor = true },
  { description = 'Focus next workspace' }
)
hl.bind(
  mod .. ' + mouse_down',
  hl.dsp.focus { workspace = '+1', on_current_monitor = true },
  { description = 'Focus previous workspace' }
)
for i = 1, 10 do
  local key = i % 10
  hl.bind(
    mod .. ' + ' .. key,
    hl.dsp.focus { workspace = i, on_current_monitor = true },
    { description = 'Focus workspace ' .. i }
  )
  hl.bind(
    mod .. ' + SHIFT + ' .. key,
    hl.dsp.window.move { workspace = i },
    { description = 'Move window to workspace ' .. i }
  )

  hl.bind(
    mod .. ' + CTRL + ' .. key,
    hl.dsp.workspace.toggle_special('special-' .. key),
    { description = 'Toggle hidden workspace ' .. key }
  )
  hl.bind(
    mod .. ' + CTRL + SHIFT + ' .. key,
    hl.dsp.window.move { workspace = 'special:special-' .. key },
    { description = 'Move window to hidden workspace ' .. key }
  )
end

hl.bind(mod .. ' + Grave', layout_toggle, { description = 'Cycle workspace layout' })
hl.bind(
  mod .. ' + Bracketleft',
  layout_bind {
    dwindle = hl.dsp.layout 'swapsplit',
    master = hl.dsp.layout 'swapprev',
    scrolling = hl.dsp.layout 'move -col',
    monocle = hl.dsp.layout 'cycleprev',
  },
  { description = 'Layout action left' }
)
hl.bind(
  mod .. ' + Bracketright',
  layout_bind {
    dwindle = hl.dsp.layout 'togglesplit',
    master = hl.dsp.layout 'swapnext',
    scrolling = hl.dsp.layout 'move +col',
    monocle = hl.dsp.layout 'cyclenext',
  },
  { description = 'Layout action right' }
)
hl.bind(
  mod .. ' + SHIFT + Bracketleft',
  layout_bind {
    dwindle = hl.dsp.layout 'splitratio -0.1',
    master = hl.dsp.layout 'cycleprev',
    scrolling = hl.dsp.layout 'swapcol l',
    monocle = hl.dsp.no_op(),
  },
  { description = 'Layout secondary action left' }
)
hl.bind(
  mod .. ' + SHIFT + Bracketright',
  layout_bind {
    dwindle = hl.dsp.layout 'splitratio +0.1',
    master = hl.dsp.layout 'cyclenext',
    scrolling = hl.dsp.layout 'swapcol r',
    monocle = hl.dsp.no_op(),
  },
  { description = 'Layout secondary action right' }
)

hl.bind(mod .. ' + F1', game_mode_toggle, { description = 'Toggle game mode' })
hl.bind(mod .. ' + F2', blur_toggle, { description = 'Toggle blur' })
hl.bind(mod .. ' + F3', gaps_toggle, { description = 'Toggle gaps and shadow' })
hl.bind(mod .. ' + F4', animation_toggle, { description = 'Toggle animations' })

hl.bind(mod .. ' + Z', zoom, { description = 'Toggle zoom' })
hl.bind(mod .. ' + Equal', function()
  zoom(0.5)
end, { repeating = true, description = 'Zoom in' })
hl.bind(mod .. ' + Minus', function()
  zoom(-0.5)
end, { repeating = true, description = 'Zoom out' })

hl.bind(
  mod .. ' + SUPER_L',
  hl.dsp.exec_cmd(ipc .. ' panel-toggle launcher'),
  { release = true, description = 'Toggle launcher' }
)
hl.bind(
  mod .. ' + ALT + C',
  hl.dsp.exec_cmd(ipc .. ' panel-toggle control-center home'),
  { description = 'Toggle control center' }
)
hl.bind(
  mod .. ' + ALT + M',
  hl.dsp.exec_cmd(ipc .. ' panel-toggle control-center media'),
  { description = 'Toggle media controls' }
)
hl.bind(
  mod .. ' + ALT + S',
  hl.dsp.exec_cmd(ipc .. ' panel-toggle control-center system'),
  { description = 'Toggle system controls' }
)
hl.bind(
  mod .. ' + ALT + N',
  hl.dsp.exec_cmd(ipc .. ' panel-toggle control-center network'),
  { description = 'Toggle network controls' }
)
hl.bind(
  mod .. ' + ALT + B',
  hl.dsp.exec_cmd(ipc .. ' panel-toggle control-center bluetooth'),
  { description = 'Toggle Bluetooth controls' }
)
hl.bind(
  mod .. ' + ALT + V',
  hl.dsp.exec_cmd(ipc .. ' panel-toggle clipboard'),
  { description = 'Toggle clipboard' }
)
hl.bind(
  mod .. ' + ALT + W',
  hl.dsp.exec_cmd(ipc .. ' panel-toggle wallpaper'),
  { description = 'Toggle wallpaper picker' }
)
hl.bind(
  mod .. ' + ALT + Q',
  hl.dsp.exec_cmd(ipc .. ' panel-toggle session'),
  { description = 'Toggle session menu' }
)
hl.bind(
  mod .. ' + ALT + Period',
  hl.dsp.exec_cmd(ipc .. ' panel-toggle launcher "/emo "'),
  { description = 'Toggle emoji picker' }
)
hl.bind(
  mod .. ' + ALT + SHIFT + W',
  hl.dsp.exec_cmd(ipc .. ' panel-toggle noctalia/wallhaven:browser'),
  { description = 'Toggle Wallhaven browser' }
)
hl.bind(
  mod .. ' + ALT + Slash',
  hl.dsp.exec_cmd(ipc .. ' panel-toggle kenn/keybind-cheatsheet:cheatsheet'),
  { description = 'Toggle keybind cheatsheet' }
)
hl.bind(
  mod .. ' + ALT + Comma',
  hl.dsp.exec_cmd(ipc .. ' settings-toggle'),
  { description = 'Toggle settings' }
)
hl.bind(
  mod .. ' + ALT + L',
  hl.dsp.exec_cmd(ipc .. ' session lock'),
  { description = 'Lock screen' }
)
hl.bind(
  mod .. ' + CTRL + S',
  hl.dsp.exec_cmd(ipc .. ' bar-toggle primary'),
  { description = 'Toggle primary bar' }
)
hl.bind(
  mod .. ' + CTRL + N',
  hl.dsp.exec_cmd(ipc .. ' nightlight-force-toggle'),
  { description = 'Toggle night light' }
)
hl.bind(
  mod .. ' + CTRL + C',
  hl.dsp.exec_cmd(ipc .. ' caffeine-toggle'),
  { description = 'Toggle caffeine mode' }
)
hl.bind(
  mod .. ' + CTRL + P',
  hl.dsp.exec_cmd(ipc .. ' power-cycle'),
  { description = 'Cycle power profile' }
)

hl.bind(
  'Print',
  hl.dsp.exec_cmd(ipc .. ' screenshot-fullscreen'),
  { description = 'Screenshot fullscreen' }
)
hl.bind(
  'CTRL + Print',
  hl.dsp.exec_cmd(ipc .. ' screenshot-region'),
  { description = 'Screenshot region' }
)
hl.bind(
  mod .. ' + S',
  hl.dsp.exec_cmd(ipc .. ' screenshot-fullscreen'),
  { description = 'Screenshot fullscreen' }
)
hl.bind(
  mod .. ' + SHIFT + S',
  hl.dsp.exec_cmd(ipc .. ' screenshot-region'),
  { description = 'Screenshot region' }
)

hl.bind(
  'XF86AudioRaiseVolume',
  hl.dsp.exec_cmd(ipc .. ' volume-up'),
  { locked = true, repeating = true, description = 'Increase volume' }
)
hl.bind(
  'XF86AudioLowerVolume',
  hl.dsp.exec_cmd(ipc .. ' volume-down'),
  { repeating = true, description = 'Decrease volume' }
)
hl.bind(
  'XF86AudioMute',
  hl.dsp.exec_cmd(ipc .. ' volume-mute'),
  { locked = true, description = 'Toggle mute' }
)
hl.bind(
  'XF86AudioMicMute',
  hl.dsp.exec_cmd(ipc .. ' mic-mute'),
  { locked = true, description = 'Toggle microphone mute' }
)
hl.bind(
  mod .. ' + XF86AudioRaiseVolume',
  hl.dsp.exec_cmd(ipc .. ' mic-volume-up'),
  { locked = true, repeating = true, description = 'Increase microphone volume' }
)
hl.bind(
  mod .. ' + XF86AudioLowerVolume',
  hl.dsp.exec_cmd(ipc .. ' mic-volume-down'),
  { locked = true, repeating = true, description = 'Decrease microphone volume' }
)
hl.bind(
  'XF86MonBrightnessUp',
  hl.dsp.exec_cmd(ipc .. ' brightness-up'),
  { repeating = true, description = 'Increase brightness' }
)
hl.bind(
  'XF86MonBrightnessDown',
  hl.dsp.exec_cmd(ipc .. ' brightness-down'),
  { repeating = true, description = 'Decrease brightness' }
)
hl.bind(
  'XF86AudioPlay',
  hl.dsp.exec_cmd(ipc .. ' media toggle'),
  { locked = true, description = 'Toggle playback' }
)
hl.bind(
  'XF86AudioNext',
  hl.dsp.exec_cmd(ipc .. ' media next'),
  { locked = true, description = 'Next track' }
)
hl.bind(
  'XF86AudioPrev',
  hl.dsp.exec_cmd(ipc .. ' media previous'),
  { locked = true, description = 'Previous track' }
)
