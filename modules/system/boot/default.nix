{ pkgs, ... }:

{
  boot = {
    loader = {
      timeout = 1;
      efi.canTouchEfiVariables = true;

      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };
    };

    plymouth = {
      enable = true;
      theme = "deus_ex";

      themePackages = [
        (pkgs.adi1090x-plymouth-themes.override { selected_themes = [ "deus_ex" ]; })
      ];
    };

    kernelPackages = pkgs.linuxPackages_testing;

    kernelParams = [
      "quiet"
      "splash"
      "rd.udev.log_level=3"
      "rd.systemd.show_status=auto"
      "video=efifb:nobgrt"
    ];

    kernel.sysctl = {
      "vm.overcommit_memory" = "1";
      "vm.swappiness" = 150;
      "vm.page-cluster" = 0;
    };

    consoleLogLevel = 3;

    initrd = {
      kernelModules = [ "i915" ];
      systemd.network.wait-online.enable = true;
    };
  };
}
