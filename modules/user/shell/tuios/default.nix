{ pkgs, inputs, ... }:

{
  home.packages = [
    inputs.tuios.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
