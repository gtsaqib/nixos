{ ... }:

{
  programs = {
    fish.interactiveShellInit = ''
      source $XDG_CONFIG_HOME/fzf/themes/noctalia.fish
    '';
    fzf.enable = true;
  };

}
