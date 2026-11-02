{ ... }:

{
  programs.git = {
    enable = true;
    settings = {
      init.defaultBranch = "main";
      user = {
        email = "gtsaqib@proton.me";
        name = "g_ts";
      };
    };
  };
}
