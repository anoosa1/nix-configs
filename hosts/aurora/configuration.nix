# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).
{
  inputs,
  lib,
  config,
  pkgs,
  outputs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;
    supportedFilesystems = ["ntfs"];
    plymouth = {
      enable = true;
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
    # Hide the OS choice for bootloaders.
    # It's still possible to open the bootloader list by pressing any key
    # It will just not appear on screen unless a key is pressed
    loader.timeout = 0;
  };

  nix = {
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

  networking = {
    hostName = "aurora";

    # Pick only one of the below networking options.
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    networkmanager = {
      enable = true; # Easiest to use and most distros use this by default.
    };
  };

  # Set your time zone.
  time = {
    timeZone = "America/Toronto";
    hardwareClockInLocalTime = true;
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    #keyMap = "us";
    useXkbConfig = true; # use xkbOptions in tty.
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

  hardware = {
    enableAllFirmware = true;

    graphics = {
      enable = true;
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

  # bluetooth
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

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

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  documentation = {
    nixos = {
      enable = false;
    };
  };
  # system packages
  environment = {
    systemPackages =
      (with pkgs; [
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
      ]);
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

      dedicatedServer = {
        openFirewall = true;
      };

      extraCompatPackages = [
        pkgs.proton-ge-bin
        pkgs.winewowPackages.waylandFull
      ];

      extraPackages = [
        pkgs.gamescope
      ];

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

    hyprland = {
      enable = true;
      withUWSM = true;

      xwayland = {
        enable = true;
      };
    };
  };

  # security settings
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
      };
    };

    # rtkit is optional but recommended
    rtkit = {
      enable = true;
    };
  };

  # xdg-desktop-portal
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
  };

  # polkit
  #security.polkit.enable = true;
  #systemd = {
  #  user.services.polkit-gnome-authentication-agent-1 = {
  #    description = "polkit-gnome-authentication-agent-1";
  #    wantedBy = [ "graphical-session.target" ];
  #    wants = [ "graphical-session.target" ];
  #    after = [ "graphical-session.target" ];
  #    serviceConfig = {
  #      Type = "simple";
  #      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
  #      Restart = "on-failure";
  #      RestartSec = 1;
  #      TimeoutStopSec = 10;
  #    };
  #  };
  #  extraConfig = ''
  #    DefaultTimeoutStopSec=10s
  #  '';
  #};

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking = {
    firewall = {
      enable = false;
      allowedTCPPorts = [ 2049 ];
      allowPing = true;
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
