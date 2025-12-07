{
  lib,
  config,
  ...
}:
{
  options.anoosa.git = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable git";
      example = true;
    };

    user = {
      name = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = config.home.username;
        description = "Default user name to use";
      };

      email = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Default user email to use";
      };
    };
  };

  config = lib.mkIf config.anoosa.git.enable {
    programs = {
      git = {
        enable = true;

        settings = {
          aliases = {
            co = "checkout";
            c = "commit -a";
            a = "add -A";
            p = "push";
          };

          user = {
            inherit (config.anoosa.git.user) name email;
          };
        };

        signing = {
          format = "ssh";
          signByDefault = true;
          key = "~/.local/etc/ssh/id_ed25519.pub";
        };

        lfs = {
          enable = true;
        };
      };
    };
  };
}
