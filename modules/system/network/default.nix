{ config, ... }:

{
  networking = {
    hostName = "gts";
    wireless.enable = true;
    networkmanager.enable = true;
    nftables.enable = true;

    firewall = {
      enable = true;

      trustedInterfaces = [
        config.services.tailscale.interfaceName
        "br-62e516a13025"
      ];

      allowedUDPPorts = [ config.services.tailscale.port ];
    };
  };

  systemd = {
    services.tailscaled.serviceConfig.Environment = [ "TS_DEBUG_FIREWALL_MODE=nftables" ];
    network.wait-online.enable = false;
  };
}
