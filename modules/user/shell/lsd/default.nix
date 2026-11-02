{ ... }:

{
  programs.lsd = {
    enable = true;
    settings = {
      date = "relative";
      color.theme = "custom";

      sorting = {
        column = "extension";
        dir-grouping = "first";
      };

      hyperlink = "auto";
    };
  };
}
