{
  pkgs,
  lib,
  inputs,
  config,
  ...
}: {
  imports = [
    ./home-manager.nix
    ./stylix.nix
    ./sops.nix
  ];

  ## nix
  nix = {
    enable = true;
    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = true;
      substituters = [
        "https://cache.nixos.org"
        "https://attic.xuyh0120.win/lantian"
      ];

      trusted-public-keys = [
        "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
      ];
    };
  };

  ## environment
  environment = {
    # variables
    sessionVariables = rec {
      XDG_CACHE_HOME = "$HOME/.local/var/cache";
      XDG_CONFIG_HOME = "$HOME/.local/etc";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/var/state";
      ZDOTDIR = "$XDG_CONFIG_HOME/zsh";

      XDG_BIN_HOME = "$HOME/.local/bin";
      PATH = [
        "${XDG_BIN_HOME}"
      ];
    };

    # system packages
    systemPackages = with pkgs; [
      linux-firmware
      ffmpeg
      neofetch
    ];

    pathsToLink = ["/share/applications" "/share/xdg-desktop-portal"];
  };

  programs = {
    zsh = {
      enable = true;
    };
  };

  ## security
  sops = {
    secrets = {
      "cloudflare" = {
        owner = "acme";
      };
    };
  };

  security = {
    acme = {
      acceptTerms = true;
      defaults = {
        email = "anas@asherif.xyz";
        dnsProvider = "cloudflare";
        dnsResolver = "1.1.1.1:53";
        dnsPropagationCheck = true;
        credentialFiles = {
          "CF_DNS_API_TOKEN_FILE" = "/run/secrets/cloudflare";
        };
      };
    };

    pam = {
      services = {
        swaylock = {};

        su = {
          requireWheel = true;
        };

        system-login = {
          failDelay = {
            enable = true;
            delay = 4000000;
          };
        };

        greetd = {
          gnupg = {
            enable = true;
            storeOnly = true;
            noAutostart = true;
          };
        };
      };
    };

    # polkit
    polkit = {
      enable = true;
    };

    # rtkit
    rtkit = {
      enable = true;
    };
  };

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