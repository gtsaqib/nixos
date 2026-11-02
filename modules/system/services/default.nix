{ pkgs, ... }:

{
  security.pam.services.greetd.enableGnomeKeyring = true;

  services = {
    upower.enable = true;
    openssh.enable = true;
    power-profiles-daemon.enable = true;

    gnome = {
      gnome-keyring.enable = true;
      gcr-ssh-agent.enable = false;
    };

    gvfs.enable = true;
    tailscale.enable = true;
    cloudflare-warp.enable = true;
  };

  programs = {
    fish.enable = true;
    ssh.startAgent = true;
    dconf.enable = true;
  };

  virtualisation.docker.enable = true;

  environment = {
    systemPackages = with pkgs; [
      wget
      curl
      sops
      nurl
      nix-init
    ];
    pathsToLink = [
      "/share/applications"
      "/share/xdg-desktop-portal"
    ];
  };
}
