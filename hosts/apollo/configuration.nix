{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    inputs.niri.nixosModules.niri
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
      substituters = [
        "https://cache.nixos.org"
        "https://hyprland.cachix.org"
        "https://veloren-nix.cachix.org"
      ];
      trusted-public-keys = [
        "veloren-nix.cachix.org-1:zokfKJqVsNV6kI/oJdLF6TYBdNPYGSb+diMVQPn/5Rc="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };
  };

  ## networking
  networking = {
    # hostname
    hostName = "apollo";

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
    font = "${pkgs.terminus_font}/share/consolefonts/ter-i32n.psf.gz";
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
  };

  powerManagement.enable = true;

  nixpkgs = {
    overlays = [
      inputs.apkgs.overlays.default
      inputs.niri.overlays.niri
    ];

    config = {
      # allow unfree packages
      allowUnfree = true;

      permittedInsecurePackages = [
        "broadcom-sta-6.30.223.271-57-6.15.6"
      ];
    };
  };

  documentation = {
    nixos = {
      enable = false;
    };
  };

  programs = {
    niri = {
      enable = true;
    };

    dconf = {
      enable = true;
    };

    gnupg = {
      agent = {
        enable = true;
        #enableSSHSupport = true;
      };
    };

    uwsm = {
      enable = true;

      waylandCompositors = {
        river = {
          prettyName = "River";
          comment = "River (UWSM)";
          binPath = "/etc/profiles/per-user/anas/bin/river";
        };

        niri = {
          prettyName = "Niri";
          comment = "Niri (UWSM)";
          binPath = "/run/current-system/sw/bin/niri";
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
