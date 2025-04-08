{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    ./dwl.nix
  ];

  wayland = {
    windowManager = {
      dwl = {
        enable = true;
        config = ./config.def.h;
      };
    };
  };
}
