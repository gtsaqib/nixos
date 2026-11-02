{ config, ... }:

{
  home.sessionVariables.LG_CONFIG_FILE = "${config.xdg.configHome}/lazygit/config.yml,${config.xdg.configHome}/lazygit/themes/noctalia.yml";

  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        tabWidth = 2;
        sidePanelWidth = 0.3;
      };
      git.diffRenderers = [
        {
          type = "extDiff";
          command = "difft --color=always --background={{colorScheme}} --context={{diffContext}}";
        }
      ];
    };
  };
}
