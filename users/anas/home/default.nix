{
  pkgs,
  config,
  ...
}:
{
  imports = [
    ./packages.nix
    ./shell.nix
    ./variables.nix
  ];

  home = {
    username = "anas";
    homeDirectory = "/home/anas";
    preferXdgDirectories = true;
    stateVersion = "24.11";

    pointerCursor = {
      dotIcons = {
        enable = false;
      };
    };

    #file = {
    #  ".screenrc".source = dotfiles/screenrc;
    #  ".screenrc".text = "";
    #};
  };

  gtk = {
    gtk2 = {
      configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
    };
  };

  xresources = {
    path = "${config.xdg.configHome}/Xresources";
  };

  xdg = {
    cacheHome = "${config.home.homeDirectory}/.local/var/cache";
    configHome = "${config.home.homeDirectory}/.local/etc";
    stateHome = "${config.home.homeDirectory}/.local/var/state";
    dataHome = "${config.home.homeDirectory}/.local/share";

    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "${config.home.homeDirectory}/desktop";
      documents = "${config.home.homeDirectory}/docs";
      download = "${config.home.homeDirectory}/dls";
      music = "${config.home.homeDirectory}/audio";
      pictures = "${config.home.homeDirectory}/pics";
      videos = "${config.home.homeDirectory}/vids";
      publicShare = "${config.xdg.userDirs.documents}/public";
      templates = "${config.xdg.userDirs.documents}/templates";
    };

    portal = {
      enable = true;
      xdgOpenUsePortal = true;

      config = {
        preferred = {
          default = [
            "gnome"
            "gtk"
          ];

          "org.freedesktop.impl.portal.Access" = [
            "gtk"
          ];

          "org.freedesktop.impl.portal.Notification" = [
            "gtk"
          ];

          "org.freedesktop.impl.portal.Secret" = [
            "gnome-keyring"
          ];
        };
      };

      extraPortals = [
        pkgs.xdg-desktop-portal-gnome
      ];
    };
  };
}
