{ config, pkgs, ... }:

{
  stylix = {
    enable = true;

    image = ./wallpaper.jpg;

    base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";

    polarity = "dark";

    cursor = {
      package = pkgs.bibata-cursors;
      size = 24;
      name = "Bibata-Modern-Ice";
    };

    fonts = {
      monospace = {
        package = pkgs.monocraft;
        name = "Monocraft";
      };

      serif = config.stylix.fonts.monospace;
      sansSerif = config.stylix.fonts.monospace;

      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };

    opacity = {
      desktop = 0.8;
      terminal = 0.9;
    };

    targets = {
      plymouth = {
        enable = true;
        logoAnimated = false;
      };

      nixvim = {
        enable = true;

        transparentBackground = {
          main = true;
        };
      };
    };
  };
}
