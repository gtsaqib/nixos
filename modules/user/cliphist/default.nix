{ pkgs, ... }:

{
  home.packages = with pkgs; [
    wl-clipboard
    wl-clip-persist
  ];

  services.cliphist.enable = true;
}
