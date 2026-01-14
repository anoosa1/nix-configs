{
  lib,
  pkgs,
  config,
  ...
}:
{
  options.anoosa.mbsync.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable mbsync";
    example = true;
  };

  config = lib.mkIf config.anoosa.mbsync.enable {
    home.packages = [
      pkgs.cyrus-sasl-xoauth2
    ];

    programs = {
      mbsync = {
        enable = true;
        package = pkgs.isync.override { withCyrusSaslXoauth2 = true; };
      };
    };
  };
}
