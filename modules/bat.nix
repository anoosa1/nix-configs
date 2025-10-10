{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.anoosa.bat.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable bat";
    example = true;
  };

  config = lib.mkIf config.anoosa.bat.enable {
    programs = {
      bat = {
        enable = true;

        config = {
          pager = "less -FR";
        };

        extraPackages = with pkgs.bat-extras; [
          batdiff
          batman
          batgrep
          prettybat
        ];
      };
    };
  };
}
