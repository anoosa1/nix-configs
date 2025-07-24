{
  lib,
  config,
  ...
}:
{
  options.anoosa.notmuch.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable notmuch";
    example = true;
  };

  config = lib.mkIf config.anoosa.notmuch.enable {
    programs = {
      notmuch = {
        enable = true;

        hooks = {
          preNew = "mbsync --all";
        };
      };
    };
  };
}
