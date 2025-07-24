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

    userName = lib.mkOption {
      type = lib.types.string;
      default = null;
      description = "Default user name to use";
    };

    userEmail = lib.mkOption {
      type = lib.types.string;
      default = null;
      description = "Default user email to use";
    };
  };

  config = lib.mkIf config.anoosa.git.enable {
    programs = {
      git = {
        enable = true;
        userName = config.anoosa.git.userName;
        userEmail = config.anoosa.git.userEmail;

        aliases = {
          co = "checkout";
          c = "commit -a";
          a = "add -A";
          p = "push";
        };

        signing = {
          format = "ssh";
          signByDefault = true;
        };

        delta = {
          enable = true;
        };

        lfs = {
          enable = true;
        };
      };
    };
  };
}
