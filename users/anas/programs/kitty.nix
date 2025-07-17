{
  lib,
  config,
  ...
}:
{
  options.anoosa.kitty.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable kitty";
    example = true;
  };

  config = lib.mkIf config.anoosa.kitty.enable {
    programs = {
      kitty = {
        enable = true;
        themeFile = "gruvbox-dark-hard";

        shellIntegration = {
          enableZshIntegration = true;
        };

        settings = {
          window_padding_width = 10;
          scrollback_lines = 5000;
        };
      };
    };
  };
}
