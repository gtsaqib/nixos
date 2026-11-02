{ pkgs, ... }:

{

  home.packages = with pkgs; [
    libqalculate
    (python3.withPackages (ps: with ps; [ pygobject3 ]))
  ];

  systemd.user.sessionVariables.GI_TYPELIB_PATH = "$GI_TYPELIB_PATH:${
    pkgs.lib.makeSearchPath "lib/girepository-1.0" (
      with pkgs;
      [
        gtk3
        gtk-layer-shell
        gobject-introspection
        pango.out
        harfbuzz
        gdk-pixbuf
        atk
      ]
    )
  }";

  programs.noctalia = {
    enable = true;
    settings = ./config.toml;
  };

  xdg.configFile = {
    "noctalia/templates".source = ./templates;
    "noctalia/scripts".source = ./scripts;
  };
}
