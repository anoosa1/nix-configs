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
    supportedfilesystems = ["ntfs"];
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
    hostName = "apollo";

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

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    #keyMap = "us";
    useXkbConfig = true; # use xkbOptions in tty.
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

    facetimehd = {
      enable = true;
    };

    graphics = {
      enable = true;
    };
  };

  powerManagement.enable = true;

  # bluetooth
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

  services = {
    xserver = {
      enable = true;
      excludePackages = [
        pkgs.xterm
      ];
      # Enable the GNOME Desktop Environment.
      displayManager = {
        gdm = {
          enable = true;
        };
      };
      desktopManager = {
        gnome = {
          enable = true;
          extraGSettingsOverridePackages = [pkgs.mutter];
          extraGSettingsOverrides = ''
            [org.gnome.mutter]
            experimental-features=['scale-monitor-framebuffer']
          '';
        };
      };
    };

    # gnome
    gnome = {
      # gnome-keyring
      gnome-keyring = {
        enable = true;
      };
      core-utilities = {
        enable = lib.mkForce false;
      };
      sushi = {
        enable = true;
      };
    };

    # nfs
    nfs = {
      server = {
        enable = true;
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
        code-cursor
        flatpak
        git
        gnome-tweaks
        inputs.nixvim.packages.${system}.default
        linux-firmware
        localsend
        monocraft
        nautilus
        neofetch
        pulsemixer
        starship
        zsh
      ])
      ++ (with pkgs.gnomeExtensions; [
        appindicator
        blur-my-shell
        color-picker
      ]);
    gnome.excludePackages =
      (with pkgs; [
        gnome-tour
      ]);
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;

  programs = {
    adb = {
      enable = true;
    };
    dconf = {
      enable = true;
      profiles.gdm = {
        databases = [
          {
            lockAll = true;
            settings = {
              "org/gnome/desktop/interface" = {
                color-scheme = "prefer-dark";
                clock-format = "12h";
                clock-show-weekday = true;
                show-battery-percentage = true;
                cursor-theme = "Bibata-Modern-Ice";
              };
            };
          }
        ];
      };
    };
  };

  programs.gnupg.agent = {
    enable = true;
  #  enableSSHSupport = true;
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

  # List services that you want to enable:

  # flatpak
  services.flatpak.enable = true;

  # dbus
  #services.dbus = {
  #  enable = true;
  #  implementation = "broker";
  #};

  # xdg-desktop-portal
  #xdg.portal = {
  #  enable = true;
  #  # wlr.enable = true;
  #  # gtk portal needed to make gtk apps happy
  #  extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
  #};

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

  security.pam.services.gdm.enableGnomeKeyring = true;

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    # require public key authentication for better security
    #settings = {
    #  PasswordAuthentication = false;
    #  KbdInteractiveAuthentication = false;
    #  PermitRootLogin = "no";
    #};
  };
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

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  #system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
