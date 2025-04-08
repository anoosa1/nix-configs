{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.wayland.windowManager.dwl;
in
{
  options = {
    wayland = {
      windowManager = {
        dwl = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = ''
              Whether to enable configuration for dwl.
            '';
          };

          package = lib.mkPackageOption pkgs "dwl" {
            extraDescription = ''
              Which package to use for dwl.
            '';
          };

          config = lib.mkOption {
            type = lib.types.path;
            default = null;

            description = ''
              config.h file for dwl.
            '';
          };

          patches = lib.mkOption {
            type = lib.types.listOf lib.types.path;
            default = [];

            description = ''
              A list of patches to apply to dwl.
              Each element can be a local file path or a fetchpatch expression.
              For example: [ ./my-patch.diff (pkgs.fetchpatch { ... }) ]
            '';
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    nixpkgs = {
      overlays = [
        (final: prev: {
          dwl = prev.dwl.overrideAttrs {
            configH = cfg.config;
            patches = cfg.patches;
          };
        })
      ];
    };

    home = {
      packages = [
        cfg.package
      ];
    };
  };
}
