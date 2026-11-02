{ ... }:

{
  imports = [
    ../hardware-configuration.nix
    ../modules/system/boot/default.nix
    ../modules/system/hardware/default.nix
    ../modules/system/network/default.nix
    ../modules/system/nix/default.nix
    ../modules/system/nh/default.nix
    ../modules/system/services/default.nix
    ../modules/system/users/default.nix
    ../modules/system/fonts/default.nix
    ../modules/system/hyprland/default.nix
    ../modules/system/noctalia/default.nix
    ../modules/system/noctalia-greeter/default.nix
    ../modules/system/helium/default.nix
    ../modules/system/zen-browser/default.nix
  ];

  system.stateVersion = "26.05";
}
