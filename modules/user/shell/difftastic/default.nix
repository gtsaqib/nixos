{ ... }:

{
  programs = {
    difftastic = {
      enable = true;
      options = {
        color = "always";
        display = "side-by-side";
        tab-width = 2;
      };
    };
    git.settings.alias.dift = "-c diff.external=difft diff";
  };
}
