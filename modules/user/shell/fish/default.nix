{
  config,
  pkgs,
  ...
}:

{
  home.shell.enableFishIntegration = true;

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      if test -r ${config.sops.secrets."github/RujakRujakan/flake_access".path}
        set -gx NIX_CONFIG "access-tokens = github.com=$(string trim (cat ${
          config.sops.secrets."github/RujakRujakan/flake_access".path
        }))"
      end
    '';

    plugins = [
      {
        name = "done";
        src = pkgs.fishPlugins.done.src;
      }
      {
        name = "autopair";
        src = pkgs.fishPlugins.autopair.src;
      }
    ];
  };
}
