{
  pkgs,
  ...
}:
{
  fonts.fontconfig.enable = true;

  systemd.user.services = {
    "wait-for-path" = {
      Unit = {
        Description = "wait for systemd units to have full PATH";
      };

      Install = {
        WantedBy = [ "xdg-desktop-portal.service" ];
        Before = [ "xdg-desktop-portal.service" ];
      };

      Service = {
        Path = with pkgs; [ systemd coreutils gnugrep ];
        ExecStart = "${pkgs.writeShellScript "wait-for-path" ''
          #!/bin/sh
          ispresent () {
            systemctl --user show-environment | grep -E '^PATH=.*/.nix-profile/bin'
          }
          while ! ispresent; do
            sleep 0.1;
          done
        ''}";
        Type = "oneshot";
        TimeoutStartSec = "60";
      };
    };
  };

  programs = {
    gpg = {
      enable = true;
    };
  };

  services = {
    dunst = {
      enable = true;

      settings = {
        global = {
          browser = "$BROWSER";
          dmenu = "${pkgs.dmenu}/bin/dmenu";
          follow = "mouse";
          format = "<b>%s</b>\\n%b";
          frame_width = 2;
          width = "370";
          height = "350";
          offset = "10x10";
          #geometry = "500x5-0+0";
          horizontal_padding = 8;
          icon_position = "off";
          line_height = 0;
          markup = "full";
          padding = 8;
          separator_height = 2;
          transparency = 10;
          word_wrap = true;
        };

        urgency_low = {
          timeout = 10;
        };

        urgency_normal = {
          timeout = 15;
        };

        urgency_critical = {
          timeout = 0;
        };
      };
    };

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

    mpd = {
      enable = true;
      musicDirectory = "~/audio";
      network = {
        listenAddress = "any";
        port = 6600;
        startWhenNeeded = true;
      };
    };

    mpd-mpris = {
      enable = true;
    };

    playerctld = {
      enable = true;
    };

    #unclutter = {
    #  enable = true;
    #};

    wpaperd = {
      enable = true;
    };
  };
}
