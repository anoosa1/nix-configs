{
  lib,
  config,
  ...
}:
{
  options.anoosa.gpg.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable gpg";
    example = true;
  };

  config = lib.mkIf config.anoosa.gpg.enable {
    programs = {
      gpg = {
        enable = true;
        homedir = "${config.xdg.dataHome}/gnupg";
      };
    };
  };
}
