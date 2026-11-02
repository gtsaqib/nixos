{ lib, pkgs, ... }:

{
  xdg = {
    mimeApps = {
      enable = true;
      defaultApplications = {
        "inode/directory" = "org.gnome.Nautilus.desktop";
        "application/x-gnome-saved-search" = "org.gnome.Nautilus.desktop";
        "text/html" = "helium.desktop";
        "x-scheme-handler/http" = "helium.desktop";
        "x-scheme-handler/https" = "helium.desktop";
        "x-scheme-handler/about" = "helium.desktop";
        "x-scheme-handler/unknown" = "helium.desktop";
        "image/*" = "org.gnome.Loupe.desktop";
        "video/*" = "com.github.rafostar.Clapper.desktop";
        "audio/*" = "com.github.neithern.g4music.desktop";
      };
    };

    portal = {
      enable = lib.mkForce true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

      config.common = {
        "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
        "org.freedesktop.impl.portal.Settings" = [ "gtk" ];
        "org.freedesktop.impl.portal.OpenURI" = [ "gtk" ];
        default = [ "gtk" ];
      };
    };
  };
}
