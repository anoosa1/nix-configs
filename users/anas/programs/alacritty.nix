{
  lib,
  config,
  ...
}:
{
  options.anoosa.alacritty.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable alacritty";
    example = true;
  };

  config = lib.mkIf config.anoosa.alacritty.enable {
    programs = {
      alacritty = {
        enable = true;
        settings = {
          window = {
            padding = {
              x = 16;
              y = 10;
            };
            dynamic_padding = false;
            title = "Alacritty";
            decorations_theme_variant = "Dark";
            class = {
              instance = "Alacritty";
              general = "Alacritty";
            };
          };
          scrolling = {
            history = 5000;
          };
          font = {
            offset = {
              x = 0;
              y = 1;
            };
          };
          cursor = {
            style = "Beam";
          };
          terminal = {
            shell = {
              program = "zsh";
              args = [
                "--login"
                "--interactive"
              ];
            };
          };
          keyboard = {
            bindings = [
              {
                key = "V";
                mods = "Control|Shift";
                action = "Paste";
              }
              {
                key = "C";
                mods = "Control|Shift";
                action = "Copy";
              }
              {
                key = "Insert";
                mods = "Shift";
                action = "PasteSelection";
              }
              {
                key = "Key0";
                mods = "Control";
                action = "ResetFontSize";
              }
              {
                key = "Equals";
                mods = "Control";
                action = "IncreaseFontSize";
              }
              {
                key = "Plus";
                mods = "Control";
                action = "IncreaseFontSize";
              }
              {
                key = "Minus";
                mods = "Control";
                action = "DecreaseFontSize";
              }
              {
                key = "F11";
                mods = "None";
                action = "ToggleFullscreen";
              }
              {
                key = "Paste";
                mods = "None";
                action = "Paste";
              }
              {
                key = "Copy";
                mods = "None";
                action = "Copy";
              }
              {
                key = "L";
                mods = "Control";
                action = "ClearLogNotice";
              }
              {
                key = "PageUp";
                mods = "None";
                action = "ScrollPageUp";
                mode = "~Alt";
              }
              {
                key = "PageDown";
                mods = "None";
                action = "ScrollPageDown";
                mode = "~Alt";
              }
              {
                key = "Home";
                mods = "Shift";
                action = "ScrollToTop";
                mode = "~Alt";
              }
              {
                key = "End";
                mods = "Shift";
                action = "ScrollToBottom";
                mode = "~Alt";
              }
            ];
          };
        };
      };
    };
  };
}
