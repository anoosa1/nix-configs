{
  config,
  pkgs,
  ...
}:
{
  stylix = {
    enable = true;
    image = ../../wallpaper.jpg;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
    polarity = "dark";
    autoEnable = false;

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
        package = pkgs.font-awesome-pro;
        name = "Font Awesome 6 Pro Regular";
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
      };

      kitty = {
        enable = true;
      };

      niri = {
        enable = true;
      };

      sxiv = {
        enable = true;
      };

      starship = {
        enable = true;
      };

      swaylock = {
        enable = true;
      };

      tmux = {
        enable = true;
      };

      qutebrowser = {
        enable = true;
      };

      river = {
        enable = true;
      };

      wpaperd = {
        enable = true;
      };

      zathura = {
        enable = true;
      };
    };
  };
}
