{ ... }:

{
  imports = [
    ../modules/user/sops/default.nix
    ../modules/user/hyprland/default.nix
    ../modules/user/noctalia/default.nix
    ../modules/user/theme/default.nix
    ../modules/user/packages/default.nix
    ../modules/user/cliphist/default.nix
    ../modules/user/xdg/default.nix
    ../modules/user/kitty/default.nix
    ../modules/user/ghostty/default.nix
    ../modules/user/shell/default.nix
    ../modules/user/ai/default.nix
    ../modules/user/spicetify/default.nix
    ../modules/user/obs-studio/default.nix
    ../modules/user/zed-editor/default.nix
  ];

  home.stateVersion = "26.05";
}
