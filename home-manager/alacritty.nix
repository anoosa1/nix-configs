{ config, pkgs, ... }:

{
  home.packages = [ pkgs.alacritty ];

  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        padding = {
	  x = 16;
	  y = 10;
	};
	dynamic_padding = false;
        #opacity = 0.9;
	title = "Alacritty";
	class = {
	  instance = "Alacritty";
	  general = "Alacritty";
	};
      };
      scrolling = {
        history = 5000;
      };
      font = {
        normal = {
          family = "Monocraft";
          style = "Regular";
	};
        bold = {
          family = "Monocraft";
          style = "Bold";
	};
        italic = {
          family = "Monocraft";
          style = "Italic";
	};
        bold_italic = {
          family = "Monocraft";
          style = "Bold Italic";
	};
        size = 12;
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
          program = "${pkgs.zsh}/bin/zsh";
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
          #{
          #  key = "L";
          #  mods = "Control";
          #  chars = "\\x0c";
          #}
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
}
