{ ... }:

{
  programs = {
    fish.interactiveShellInit = ''
      source $XDG_CONFIG_HOME/noctalia/generated/fzf.fish
    '';
    fzf.enable = true;
  };

}
