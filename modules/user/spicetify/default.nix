{ pkgs, inputs, ... }:

let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
  ];

  programs.spicetify = {
    enable = true;
    wayland = true;

    spotifyPackage = pkgs.spotify.overrideAttrs (oldAttrs: {
      postFixup = (oldAttrs.postFixup or "") + ''
        wrapProgram $out/share/spotify/spotify --add-flags "--enable-features=UseOzonePlatform --ozone-platform=wayland"
      '';
    });

    # theme = spicePkgs.themes.hazy;

    enabledExtensions = with spicePkgs.extensions; [
      autoSkipVideo
      keyboardShortcut
      hidePodcasts
      shuffle
      skipStats
      copyToClipboard
      history
      adblock
    ];
  };
}
