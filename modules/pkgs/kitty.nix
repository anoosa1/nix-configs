# modules/pkgs/kitty.nix
{
  self,
  inputs,
  ...
}:
{
  flake.wrappers.kitty = { config, pkgs, lib, ... }: {
    imports = [ inputs.wrappers.lib.modules.default ];

    options = {
      settings = lib.mkOption {
        default = {
          font_size = 16;
          font_family = "Comic Code";
          italic_font = "Comic Code Italic";
          bold_font = "Comic Code Bold";
          bold_italic_font = "Comic Code Bold Italic";
  
          background = self.theme.base00;
          foreground = self.theme.base07;
          background_opacity = "0.9";
          color0 = self.theme.base00;
          color1 = self.theme.base08;
          color2 = self.theme.base0B;
          color3 = self.theme.base0A;
          color4 = self.theme.base0D;
          color5 = self.theme.base0E;
          color6 = self.theme.base0C;
          color7 = self.theme.base03;
          color8 = self.theme.base02;
          color9 = self.theme.base08;
          color10 = self.theme.base0B;
          color11 = self.theme.base0A;
          color12 = self.theme.base0D;
          color13 = self.theme.base0E;
          color14 = self.theme.base0C;
          color15 = self.theme.base03;
  
          selection_foreground = self.theme.base02;
          selection_background = self.theme.base01;
  
          active_tab_foreground = self.theme.base0B;
          active_tab_background = self.theme.base03;
          inactive_tab_background = self.theme.base01;
  
          cursor = self.theme.base07;
          cursor_text_color = self.theme.base00;
          shell = "${pkgs.lib.getExe pkgs.zsh} -l";
          shell_integration = "enabled";
          window_padding_width = 10;
          enable_audio_bell = "no";
        };

        type = with lib.types; attrsOf (oneOf [
          str
          bool
          int
          float
        ]);

        description = ''
          Configuration of kitty.
          See {manpage}`kitty(1)` or <https://sw.kovidgoyal.net/kitty>
        '';
      };
    };

    config = {
      package = pkgs.lib.mkDefault pkgs.kitty;

      flags = {
        "--config" = pkgs.writeText "kitty.conf" (lib.generators.toKeyValue { mkKeyValue = lib.generators.mkKeyValueDefault { } " "; } config.settings);
      };
    };
  };
}
