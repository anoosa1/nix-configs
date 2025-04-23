{
  inputs,
  lib,
  config,
  pkgs,
  outputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  ## boot
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    supportedFilesystems = ["ntfs"];

    plymouth = {
      enable = true;
    };

    loader = {
      timeout = 0;

      systemd-boot = {
        enable = true;
        editor = false;
      };

      efi = {
        canTouchEfiVariables = true;
      };
    };

    # Enable "Silent Boot"
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
  };

  nix = {
    enable = true;
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };
  };

  ## networking
  networking = {
    # hostname
    hostName = "aurora";

    # firewall
    firewall = {
      enable = false;
      allowPing = true;

      allowedTCPPorts = [
      ];
    };

    # networkmanager
    networkmanager = {
      enable = true;
    };
  };

  # time
  time = {
    # timezone
    timeZone = "America/Toronto";
    hardwareClockInLocalTime = true;
  };

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  console = {
    enable = true;
    font = "Lat2-Terminus16";
    #keyMap = "us";
  };

  systemd.user.services."wait-for-full-path" = {
    description = "wait for systemd units to have full PATH";
    wantedBy = [ "xdg-desktop-portal.service" ];
    before = [ "xdg-desktop-portal.service" ];
    path = with pkgs; [ systemd coreutils gnugrep ];
    script = ''
      ispresent () {
        systemctl --user show-environment | grep -E '^PATH=.*/.nix-profile/bin'
      }
      while ! ispresent; do
        sleep 0.1;
      done
    '';
    serviceConfig = {
      Type = "oneshot";
      TimeoutStartSec = "60";
    };
  };

  environment.sessionVariables = rec {
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

  ## hardware

  #fileSystems."PATH" = {
  #  device = "REMOTEPATH";
  #  fsType = "nfs";
  #  options = [ "x-systemd.automount" "noauto" ];
  #};

  ## hardware
  hardware = {
    enableAllFirmware = true;

    graphics = {
      enable = true;
    };

    # bluetooth
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    # nvidia - gpu
    nvidia = {
      open = true;
      package = config.boot.kernelPackages.nvidiaPackages.beta;

      powerManagement = {
        enable = true;
      };

      modesetting = {
        enable = true;
      };
    };
  };

  powerManagement.enable = true;

  # List services that you want to enable:
  services = {
    # dbus
    dbus = {
      enable = true;
      implementation = "broker";
    };

    gvfs = {
      enable = true;
    };

    # flatpak
    flatpak = {
      enable = true;
    };

    xserver = {
      videoDrivers = ["nvidia"];
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
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time";
          user = "greeter";
        };
      };
    };

    sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;
    };
  };

  nixpkgs = {
    config = {
      # allow unfree packages
      allowUnfree = true;
    };
  };

  documentation = {
    nixos = {
      enable = false;
    };
  };

  # system packages
  environment = {
    systemPackages = with pkgs; [
        bibata-cursors
        inputs.nixvim.packages.${system}.default
        linux-firmware
        mangohud
        monocraft
        nautilus
        sushi
        neofetch
        starship
        zsh
      ];
  };

  programs = {
    dconf = {
      enable = true;
    };

    gnupg = {
      agent = {
        enable = true;
        #enableSSHSupport = true;
      };
    };

    gamescope = {
      enable = true;
      capSysNice = true;
    };

    steam = {
      enable = true;
      extraPackages = [ pkgs.gamescope ];
      extraCompatPackages = [ pkgs.proton-ge-bin ];

      dedicatedServer = {
        openFirewall = true;
      };

      gamescopeSession = {
        enable = true;
      };

      localNetworkGameTransfers = {
        openFirewall = true;
      };

      protontricks = {
        enable = true;
      };
    };

    uwsm = {
      enable = true;

      waylandCompositors = {
        sway = {
          prettyName = "River";
          comment = "River (UWSM)";
          binPath = "/home/anas/.nix-profile/bin/river";
        };

        hyprland = {
          prettyName = "Hyprland";
          comment = "Hyprland (UWSM)";
          binPath = "/home/anas/.nix-profile/bin/hyprland";
        };
      };
    };
  };

  # security
  security = {
    pam = {
      services = {
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
          enableGnomeKeyring = true;
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

  # xdg
  xdg = {
    # portal
    portal = {
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
    };
  };

  systemd = {
    user = {
      services = {
        polkit-gnome-authentication-agent-1 = {
          description = "polkit-gnome-authentication-agent-1";
          wantedBy = [ "graphical-session.target" ];
          wants = [ "graphical-session.target" ];
          after = [ "graphical-session.target" ];

          serviceConfig = {
            Type = "simple";
            ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
            Restart = "on-failure";
            RestartSec = 1;
            TimeoutStopSec = 10;
          };
        };
      };
    };
  };

  system = {
    stateVersion = "24.11";
  };
}
