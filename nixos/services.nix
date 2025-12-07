{
  pkgs,
  ...
}:
{
  ## services
  services = {
    nginx = {
      recommendedTlsSettings = true;
      recommendedProxySettings = true;

      virtualHosts = {
        "accounts.asherif.xyz" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          locations = {
            "/" = {
              proxyPass = "https://10.0.0.2:9443";
              proxyWebsockets = true;
            };
            "~ (/authentik)?/api" = {
              proxyPass = "https://10.0.0.2:9443";
              proxyWebsockets = true;
            };
          };
        };

        "p1.asherif.xyz" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          locations = {
            "/" = {
              proxyPass = "https://10.0.0.10:8006";
              proxyWebsockets = true;
            };
          };
        };
      };
    };

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

    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time";
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
