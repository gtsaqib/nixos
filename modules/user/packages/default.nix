{ pkgs, ... }:

{
  home = {
    sessionVariables.NIXOS_OZONE_WL = "1";
    packages = with pkgs; [
      nautilus
      file-roller
      papirus-folders
      loupe
      clapper
      gapless
    ];
  };
}
