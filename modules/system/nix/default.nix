{ inputs, ... }:

{
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      max-jobs = 1;
      cores = 1;
      auto-optimise-store = true;

      substituters = [
        "https://hyprland.cachix.org"
        "https://gtsaqib.cachix.org"
      ];
      trusted-substituters = [
        "https://hyprland.cachix.org"
        "https://gtsaqib.cachix.org"
      ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "gtsaqib.cachix.org-1:2o0uyw7seQ59glhJ9Epk8isXlFbvN+oL5YElsZFOMZ8="
      ];
      trusted-users = [ "@wheel" ];
    };

    daemonCPUSchedPolicy = "batch";
    daemonIOSchedClass = "idle";
  };

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      (import ../../../pkgs/default.nix)
    ];
  };
}
