{
  config,
  pkgs,
  ...
}:
{
  stylix = {
    enable = true;
    image = ../../wallpaper.png;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
    polarity = "dark";

    cursor = {
      package = pkgs.bibata-cursors;
      size = 24;
      name = "Bibata-Modern-Ice";
    };

    iconTheme = {
      enable = true;
      light = "Adwaita";
      dark = "Adwaita:dark";
      package = pkgs.adwaita-icon-theme;
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
      alacritty = {
        enable = true;
      };

      bat = {
        enable = true;
      };

      dunst = {
        enable = true;
      };

      gtk = {
        enable = true;

        flatpakSupport = {
          enable = true;
        };
      };

      sxiv = {
        enable = true;
      };

      starship = {
        enable = true;
      };

      tmux = {
        enable = true;
      };

      qt = {
        enable = false;
        #platform = "qtct";
      };

      river = {
        enable = true;
      };

      rofi = {
        enable = true;
      };

      waybar = {
        enable = false;
      };

      zathura = {
        enable = true;
      };
    };
  };
}
