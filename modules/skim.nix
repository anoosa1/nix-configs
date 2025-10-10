{
  lib,
  config,
  ...
}:
{
  options.anoosa.skim.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable skim";
    example = true;
  };

  config = lib.mkIf config.anoosa.skim.enable {
    programs = {
      skim = {
        enable = true;
        enableZshIntegration = true;
        changeDirWidgetCommand = "fd --type d";
        fileWidgetCommand = "fd --type f";

        defaultOptions = [
          "--prompt >"
          "--height 15"
        ];
      };
    };
  };
}
