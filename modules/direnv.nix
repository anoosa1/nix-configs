{
  lib,
  config,
  ...
}:
{
  options.anoosa.direnv.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable direnv";
    example = true;
  };

  config = lib.mkIf config.anoosa.direnv.enable {
    programs = {
      direnv = {
        enable = true;
        enableZshIntegration = true;
        silent = true;

        config = {
          global = {
            disable_stdin = true;
          };

          whitelist = {
            prefex = [
              "/home/anas/docs/code"
            ];
          };
        };

        nix-direnv = {
          enable = true;
        };

        #stdlib = ''
        #'';
      };
    };
  };
}
