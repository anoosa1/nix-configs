{ config, pkgs, ... }:

{
  programs = {
    gpg = {
      enable = true;
    };
  };
  services = {
    #dunst = {
    #  enable = true;
    #  settings = {
    #    global = {
    #      browser = "$XDG_DATA_HOME/flatpak/exports/bin/io.gitlab.librewolf-community -new-tab";
    #      dmenu = "${pkgs.dmenu}/bin/dmenu";
    #      follow = "mouse";
    #      font = "Monocraft 12";
    #      format = "<b>%s</b>\\n%b";
    #      frame_color = "#e5e9f0";
    #      frame_width = 2;
    #      width = "370";
    #      height = "350";
    #      offset = "10x10";
    #      #geometry = "500x5-0+0";
    #      horizontal_padding = 8;
    #      icon_position = "off";
    #      line_height = 0;
    #      markup = "full";
    #      padding = 8;
    #      separator_color = "#e5e9f0";
    #      separator_height = 2;
    #      transparency = 10;
    #      word_wrap = true;
    #    };
    #    urgency_low = {
    #      background = "#3b4252";
    #      foreground = "#4c566a";
    #      timeout = 10;
    #    };
    #    urgency_normal = {
    #      background = "#434c5e";
    #      foreground = "#e5e9f0";
    #      timeout = 15;
    #    };
    #    urgency_critical = {
    #      background = "#bf616a";
    #      foreground = "#eceff4";
    #      timeout = 0;
    #    };
    #  };
    #};
    gpg-agent = {
      enable = true;
      defaultCacheTtl = 54000;
      maxCacheTtl = 54000;
      extraConfig = ''
        allow-preset-passphrase
      '';
    };
    gnome-keyring = {
      enable = true;
    };
    #mpd = {
    #  enable = true;
    #  package = pkgs.mpd;
    #  dbFile = "~/.local/share/mpd/mpd.db";
    #  #extraConfig = ''
    #  #'';
    #  musicDirectory = "~/audio";
    #  network = {
    #    listenAddress = "any";
    #    port = 6600;
    #    startWhenNeeded = true;

    #  };
    #};
    #unclutter = {
    #  enable = true;
    #};
    #xsettingsd = {
    #  enable = true;
    #  settings = {
    #    "Gtk/EnableAnimations" = "1";
    #    "Gtk/DecorationLayout" = "icon:minimize,maximize,close";
    #    "Gtk/PrimaryButtonWarpsSlider" = "0";
    #    "Gtk/ToolbarStyle" = "3";
    #    "Gtk/MenuImages" = "1";
    #    "Gtk/ButtonImages" = "1";
    #    "Gtk/CursorThemeSize" = "24";
    #    "Gtk/CursorThemeName" = "Bibata-Modern-Ice";
    #    "Gtk/FontName" = "Monocraft,  12";
    #    "Net/ThemeName" = "adw-gtk3-dark";
    #    "Xft/Hinting" = "1";
    #    "Xft/HintStyle" = "hintslight";
    #    "Xft/Antialias" = "1";
    #    "Xft/RGBA" = "rgb";
    #  };
    #};
  };
}
