{ config, lib, ... }:

{
  home.sessionVariables.STARSHIP_CONFIG = lib.mkForce "${config.xdg.configHome}/starship.toml";

  programs = {
    fish.interactiveShellInit = ''
      function starship_transient_prompt_func
        printf " "
        starship module directory
        starship module character
      end
    '';
    starship = {
      enable = true;
      configPath = "${config.xdg.configHome}/starship-base.toml";
      settings = lib.importTOML ./config.toml;
      enableTransience = true;
    };
  };
}
