{ pkgs, ... }:

{
  users.users.g = {
    isNormalUser = true;
    description = "g";

    extraGroups = [
      "networkmanager"
      "wheel"
      "input"
      "docker"
    ];

    shell = pkgs.fish;
    useDefaultShell = true;
  };
}
