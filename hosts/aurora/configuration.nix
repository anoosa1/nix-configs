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
    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;
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
    font = "${pkgs.terminus_font}/share/consolefonts/ter-i16n.psf.gz";
    packages = with pkgs; [ terminus_font ];
    keyMap = "us";
  };

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

  services = {
    sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;
    };

    xserver = {
      videoDrivers = ["nvidia"];
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
    };

    gamemode = {
      enable = true;
      enableRenice = true;
    };

    steam = {
      enable = true;
      extraCompatPackages = [ pkgs.proton-ge-bin ];

      dedicatedServer = {
        openFirewall = true;
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
      };
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
