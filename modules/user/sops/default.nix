{ config, inputs, ... }:

{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  sops = {
    defaultSopsFile = ../../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";

    secrets = {
      "github/RujakRujakan/flake_access" = { };

      "ssh_keys/main-codeberg" = {
        mode = "0600";
        path = "${config.home.homeDirectory}/.ssh/id_main-codeberg";
      };

      "ssh_keys/main-github" = {
        mode = "0600";
        path = "${config.home.homeDirectory}/.ssh/id_main-github";
      };

      "ssh_keys/sec-github" = {
        mode = "0600";
        path = "${config.home.homeDirectory}/.ssh/id_sec-github";
      };
    };
  };
}
