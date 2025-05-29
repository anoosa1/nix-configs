{
  pkgs,
  ...
}:
{
  ## services
  services = {
    # dbus
    dbus = {
      enable = true;
      implementation = "broker";
    };

    gvfs = {
      enable = true;
    };

    # Enable the OpenSSH daemon.
    openssh = {
      enable = true;
      # require public key authentication for better security
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
      };
    };

    # pipewire
    pipewire = {
      enable = true;

      alsa = {
        enable = true;
        support32Bit = true;
      };

      pulse = {
        enable = true;
      };

      wireplumber = {
        enable = true;
      };
    };

    pulseaudio = {
      extraClientConf = "cookie-file = ~/.local/var/state/pulse/cookie";
    };

    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time";
          user = "greeter";
        };
      };
    };

    udisks2 = {
      enable = true;
    };

    upower = {
      enable = true;
    };

    power-profiles-daemon = {
      enable = true;
    };

    gnome = {
      gnome-keyring = {
        enable = true;
      };
    };
  };
}
