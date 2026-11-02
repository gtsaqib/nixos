{ pkgs, ... }:

{
  fonts = {
    enableDefaultPackages = true;

    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      liberation_ttf
      corefonts
      gyre-fonts
      geist-font
      lora
      fraunces
      lexend
      maple-mono.NF
    ];

    fontconfig.defaultFonts = {
      serif = [ "Fraunces" ];
      sansSerif = [ "Maple Mono NF" ];
      monospace = [ "Maple Mono NF" ];
    };
  };
}
