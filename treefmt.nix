{ pkgs, ... }:
{
  projectRootFile = "flake.nix";

  programs = {
    nixfmt.enable = true;
    stylua.enable = true;
    yamlfmt.enable = true;
    ruff-format.enable = true;
  };

  settings.formatter = {
    tombi = {
      command = "${pkgs.tombi}/bin/tombi";

      options = [
        "format"
        "--offline"
      ];

      includes = [ "*.toml" ];
    };
  };
}
