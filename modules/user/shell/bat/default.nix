{ ... }:

{
  home.shellAliases.cat = "bat --style plain --paging never";

  programs.bat = {
    enable = true;
    config = {
      theme = "noctalia";
    };
  };
}
