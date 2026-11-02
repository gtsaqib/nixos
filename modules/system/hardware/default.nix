{ pkgs, ... }:

{
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [ intel-media-driver ];
    };
    bluetooth = {
      enable = true;
      powerOnBoot = true;

      settings.General = {
        Experimental = true;
        FastConnection = true;
      };
    };
  };

  zramSwap = {
    enable = true;
    priority = 100;
    algorithm = "zstd";
    memoryPercent = 65;
  };

  time.timeZone = "Asia/Jakarta";
  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  environment.sessionVariables.LIBVA_DRIVER_NAME = "iHD";
}
