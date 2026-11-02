#!/usr/bin/env luajit

local mode = arg[1]
local suffix = mode == 'dark' and '-dark' or ''

local color_scheme = '/org/gnome/desktop/interface/color-scheme'
local gtk_theme = '/org/gnome/desktop/interface/gtk-theme'

if mode == 'dark' or mode == 'light' then
  os.execute(('dconf write %s "\'prefer-%s\'"'):format(color_scheme, mode))
  os.execute(('dconf write %s "\'adw-gtk3%s\'"'):format(gtk_theme, suffix))
end
