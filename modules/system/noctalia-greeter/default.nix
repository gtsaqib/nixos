{ pkgs, ... }:

{
  services.displayManager.noctalia-greeter = {
    enable = true;
    passwordlessSyncUsers = [ "g" ];

    settings = {
      output.scale = 1;

      appearance = {
        password_style = "random";
        hide_logo = true;
        scheme = "Synced";
      };

      cursor = {
        theme = "Bibata-Modern-Classic";
        size = 20;
        path = "${pkgs.bibata-cursors}/share/icons";
      };
    };
  };
}
