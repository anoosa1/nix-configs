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
      alacritty = {
        enable = true;
      };

      bat = {
        enable = true;
      };

      bemenu = {
        enable = true;
        alternate = true;
        fontSize = 16;
      };

      gtk = {
        enable = true;

        flatpakSupport = {
          enable = true;
        };
      };

      hyprland = {
        enable = true;

        hyprpaper = {
          enable = true;
        };
      };

      hyprlock = {
        enable = true;
      };

      hyprpaper = {
        enable = true;
      };

      kitty = {
        enable = true;
      };

      sxiv = {
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

      wezterm = {
        enable = true;
      };

      zathura = {
        enable = true;
      };
    };
  };
}
