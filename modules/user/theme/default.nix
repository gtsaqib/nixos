{
  config,
  lib,
  pkgs,
  ...
}:

{
  home = {
    sessionVariables = {
      GTK_USE_PORTAL = "1";
      QT_QPA_PLATFORMTHEME = lib.mkForce "qt6ct";
    };
    pointerCursor = {
      enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 20;
      hyprcursor.enable = true;
      gtk.enable = true;
      x11.enable = true;
    };
  };

  gtk = {
    enable = true;

    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };

    iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
    };

    gtk3.extraConfig.gtk-decoration-layout = ":";
    gtk4.extraConfig.gtk-decoration-layout = ":";
  };

  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style.name = "adwaita";

    qt5ctSettings.Appearance = {
      custom_palette = true;
      color_scheme_path = "${config.xdg.configHome}/qt5ct/colors/noctalia.conf";
      style = "breeze";
    };

    qt6ctSettings.Appearance = {
      custom_palette = true;
      color_scheme_path = "${config.xdg.configHome}/qt6ct/colors/noctalia.conf";
      style = "breeze";
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      gtk-decoration-layout = ":";
      font-name = "Sans 11";
      monospace-font-name = "Monospace 11";
      document-font-name = "Serif 11";
    };
    "org/gnome/desktop/wm/preferences" = {
      button-layout = ":";
      titlebar-font = "Sans 11";
    };
  };
}
