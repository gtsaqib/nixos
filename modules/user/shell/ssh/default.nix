{ ... }:

{
  home.file = {
    ".ssh/id_main-codeberg.pub".text =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOlSifNyoWxCalyWgo2iEyhXEW0SJAqlRY7YWIv7ZHPx main-codeberg";
    ".ssh/id_sec-github.pub".text =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPkoZqWWyJfEZi+gKMc1RJdBDg+sr0FpmU5xuOCXMQo5 sec-github";
    ".ssh/id_main-github.pub".text =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGiVl660mCeF1Jf7FPooSMAlwE9nwhAGa/AbhSwb6LsK main-github";
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      "codeberg.org" = {
        HostName = "codeberg.org";
        IdentityFile = "/home/g/.ssh/id_main-codeberg";
      };
      "github.com" = {
        HostName = "github.com";
        IdentityFile = "/home/g/.ssh/id_main-github";
      };
    };
  };
}
