{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.anoosa.password-store.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable pass";
    example = true;
  };

  config = lib.mkIf config.anoosa.password-store.enable {
    programs = {
      password-store = {
        enable = true;
        package = pkgs.pass-wayland.withExtensions (ext: with ext; [ pass-audit pass-otp pass-import pass-genphrase pass-update pass-tomb ]);

        settings = {
          PASSWORD_STORE_DIR = "${config.xdg.dataHome}/passwords";
          PASSWORD_STORE_CLIP_TIME = "10";
        };
      };
    };
  };
}
