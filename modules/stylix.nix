{
  inputs,
  self,
  ...
}:
{
  flake.nixosModules.stylix = { pkgs, ... }: {
    imports = [
      inputs.stylix.nixosModules.stylix
    ];

    stylix = {
      enable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
      polarity = "dark";
      autoEnable = false;

      targets = {
        plymouth = {
          enable = true;
          logoAnimated = false;
        };
      };
    };
  };

  flake.homeModules.stylix = { pkgs, ... }: {
    stylix = {
      enable = true;
      image = ../wallpaper.jpg;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
      polarity = "dark";
      autoEnable = false;

      cursor = {
        package = pkgs.bibata-cursors;
        size = 24;
        name = "Bibata-Modern-Ice";
      };

      icons = {
        enable = true;
        light = "Adwaita";
        dark = "Adwaita:dark";
        package = pkgs.adwaita-icon-theme;
      };

      fonts = {
        serif = {
          name = "Comic Code";
          package = self.packages.${pkgs.system}.comic-code;
        };

        sansSerif = {
          name = "Comic Code";
          package = self.packages.${pkgs.system}.comic-code;
        };

        sizes = {
          applications = 16;
          desktop = 12;
          popups = 12;
          terminal = 16;
        };

        monospace = {
          name = "Comic Code";
          package = self.packages.${pkgs.system}.comic-code;
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
        dunst.enable = true;
        gtk.enable = true;
        kitty.enable = true;
        niri.enable = true;
        qutebrowser.enable = true;
        starship.enable = true;
        swaylock.enable = true;
        sxiv.enable = true;
        tmux.enable = true;
        wpaperd.enable = true;
        zathura.enable = true;
      };
    };
  };
}
