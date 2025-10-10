{
  lib,
  config,
  ...
}:
{
  options.anoosa.tmux.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable tmux";
    example = true;
  };

  config = lib.mkIf config.anoosa.tmux.enable {
    programs = {
      tmux = {
        enable = true;
        baseIndex = 1;
        clock24 = true;
        focusEvents = true;
        historyLimit = 5000;
        keyMode = "vi";
        mouse = true;
        #sensibleOnTop = true;
        shortcut = "Space";
        terminal = "screen-256color";

        extraConfig = ''
          set -g allow-passthrough on
        '';
      };
    };
  };
}
