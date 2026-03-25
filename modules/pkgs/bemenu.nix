# modules/pkgs/bemenu.nix
{
  inputs,
  self,
  ...
}:
{
  flake.wrappers.bemenu = { config, pkgs, lib, ... }: {
    imports = [ inputs.wrappers.lib.modules.default ];

    options = {
      settings = lib.mkOption {
        description = "Configuration options for bemenu. See {manpage}`bemenu(1)`.";

        default = {
          ignorecase = true;
          ab = self.theme.base00;
          af = self.theme.base05;
          fb = self.theme.base00;
          ff = self.theme.base05;
          hb = self.theme.base00;
          hf = self.theme.base0A;
          nb = self.theme.base00;
          nf = self.theme.base05;
          tb = self.theme.base00;
          tf = self.theme.base08; 
        };

        type = with lib.types; attrsOf (oneOf [
            str
            number
            bool
        ]);

        example = lib.literalExpression ''
          {
            line-height = 28;
            prompt = "open";
            ignorecase = true;
            fb = "#1e1e2e";
            ff = "#cdd6f4";
            nb = "#1e1e2e";
            nf = "#cdd6f4";
            tb = "#1e1e2e";
            hb = "#1e1e2e";
            tf = "#f38ba8";
            hf = "#f9e2af";
            af = "#cdd6f4";
            ab = "#1e1e2e";
            width-factor = 0.3;
          }
        '';
      };
    };

    config = {
      package = pkgs.lib.mkDefault pkgs.bemenu;
      wrapperVariants.bemenu-run = {};

      env = {
        BEMENU_OPTS = lib.cli.toCommandLineShell (k: { option = if (builtins.stringLength k) == 1 then "-${k}" else "--${k}"; sep = null; explicitBool = false; }) config.settings;
      };
    };
  };
}
