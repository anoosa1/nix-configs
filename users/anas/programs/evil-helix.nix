{
  pkgs,
  ...
}:
{
  programs = {
    helix = {
      enable = true;
      package = pkgs.evil-helix;

      languages = {
        language = [{
          name = "nix";
          auto-format = true;
          formatter.command = "${pkgs.nixfmt-classic}/bin/nixfmt";
        }];
      };

      settings = {
        editor = {
          line-number = "relative";

          cursor-shape = {
            normal = "block";
            insert = "bar";
          };
        };

        keys = {
          normal = {
            space = {
              space = "file_picker";
              w = ":w";
              q = ":q";
            };
            esc = [ "collapse_selection" "keep_primary_selection" ];
          };
        };
      };
    };
  };
}
