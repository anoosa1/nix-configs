{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.stylix.nixosModules.stylix
  ];

  stylix = {
    enable = true;
    image = ../wallpaper.jpg;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/atelier-forest.yaml";
    polarity = "dark";

    cursor = {
      package = pkgs.bibata-cursors;
      size = 24;
      name = "Bibata-Modern-Ice";
    };

    fonts = {
      serif = config.stylix.fonts.monospace;
      sansSerif = config.stylix.fonts.monospace;

      sizes = {
        applications = 16;
        desktop = 12;
        popups = 12;
        terminal = 16;
      };

      monospace = {
        name = "Comic Code";
        package = pkgs.comic-code;
      };

      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };

    opacity = {
      terminal = 0.8;
      popups = 0.8;
    };

    targets = {
      plymouth = {
        enable = true;
        logoAnimated = false;
      };
    };
  };
}
