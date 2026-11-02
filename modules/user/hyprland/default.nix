{
  config,
  pkgs,
  inputs,
  ...
}:

{
  home = {
    sessionVariables.HYPRLAND_STUBS = "${pkgs.hyprland}/share/hypr/stubs";
    packages = [
      pkgs.hyprpicker
    ];
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    systemd.enable = false;

    extraLuaFiles = {
      config = ./config.lua;
      animation = ./animation.lua;
      binds = ./binds.lua;
      plugins = ./plugins.lua;
    };

    plugins = [
      inputs.hypr-dynamic-cursors.packages.${pkgs.stdenv.hostPlatform.system}.hypr-dynamic-cursors
    ];
  };

  xdg = {
    configFile."uwsm/env".source =
      "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";

    portal.config.hyprland.default = [
      "hyprland"
      "gtk"
    ];
  };
}
