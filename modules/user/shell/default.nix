{ pkgs, ... }:

{
  imports = [
    # ./zellij/default.nix
    ./fish/default.nix
    ./starship/default.nix
    ./lsd/default.nix
    ./bat/default.nix
    ./git/default.nix
    ./difftastic/default.nix
    ./ssh/default.nix
    ./direnv/default.nix
    ./helix/default.nix
    ./fd/default.nix
    ./dircolors/default.nix
    ./fzf/default.nix
    ./zoxide/default.nix
    ./ripgrep/default.nix
    ./yazi/default.nix
    ./fastfetch/default.nix
    ./bottom/default.nix
    ./lazygit/default.nix
  ];

  home = {
    sessionVariables.LESS = "-FXRKMij.5";
    packages = with pkgs; [
      grim
      slurp
      tesseract
      luajit
    ];
  };
}
