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

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  nixpkgs = {
    overlays = [
      inputs.apkgs.overlays.default
      inputs.niri.overlays.niri
    ];

    config = {
      # allow unfree packages
      allowUnfree = true;

      permittedInsecurePackages = [
        "broadcom-sta-6.30.223.271-59-6.12.63"
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
      fastfetch
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
    # dbus
    dbus = {
      enable = true;
      implementation = "broker";
    };

    # keyd
    keyd = {
      enable = true;

      keyboards = {
        default = {
          ids = [ "*" ];
          settings = {
            main = {
              capslock = "overload(control, esc)";
            };
          };
        };
      };
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
        PermitRootLogin = "no";
        KbdInteractiveAuthentication = false;
        AllowUsers = [ "anas" ];
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
  
  users = {
    defaultUserShell = pkgs.zsh;
  };
}
