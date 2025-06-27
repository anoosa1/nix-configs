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

  fonts = {
    fontconfig = {
      enable = true;

      defaultFonts = {
        emoji = [
          "Font Awesome 5 Pro Regular"
        ];
      };
    };
  };

  home = {
    username = "anas";
    homeDirectory = "/home/anas";
    stateVersion = "24.11";

    #file = {
    #  ".screenrc".source = dotfiles/screenrc;
    #  ".screenrc".text = "";
    #};
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
        river = {
          default = [ "gtk" ];
          "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
          "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
        };
      };

      extraPortals = [
        pkgs.xdg-desktop-portal-wlr
        pkgs.xdg-desktop-portal-gtk
      ];
    };
  };
}
