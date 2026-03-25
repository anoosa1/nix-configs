# modules/pkgs/alacritty.nix
{
  self,
  inputs,
  ...
}:
{
  flake.wrappers.alacritty = { pkgs, ... }: {
    imports = [ inputs.wrappers.lib.wrapperModules.alacritty ];

    settings = {
      colors = {
        draw_bold_text_with_bright_colors = true;

        primary = {
          background = self.theme.base00;
          foreground = self.theme.base07;
        };

        cursor = {
          text = self.theme.base00;
          cursor = self.theme.base07;
        };

        normal = {
          black   = self.theme.base00;
          red     = self.theme.base08;
          green   = self.theme.base0B;
          yellow  = self.theme.base0A;
          blue    = self.theme.base0D;
          magenta = self.theme.base0E;
          cyan    = self.theme.base0C;
          white   = self.theme.base05;
        };

        bright = {
          black   = self.theme.base03;
          red     = self.theme.base08;
          green   = self.theme.base0B;
          yellow  = self.theme.base0A;
          blue    = self.theme.base0D;
          magenta = self.theme.base0E;
          cyan    = self.theme.base0C;
          white   = self.theme.base07;
        };
      };

      font = {
        size = 16;

        normal = {
          family = "Comic Code";
          style = "Regular";
        };

        bold = {
          family = "Comic Code";
          style = "Bold";
        };

        italic = {
          family = "Comic Code";
          style = "Italic";
        };

        bold_italic = {
          family = "Comic Code";
          style = "Bold Italic";
        };
      };

      terminal = {
        shell = {
          program = pkgs.lib.getExe pkgs.zsh;
          args = [ "-l" ];
        };
      };

      window = {
        opacity = 0.9;

        padding = {
          x = 10;
          y = 10;
        };
      };
    };
  };
}
