# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:

let
  unstable = import <nixos-unstable> {};
in

  {
    imports =
      [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    #lanzaboote = {
    #  enable = true;
    #  pkiBundle = "/etc/secureboot";
    #};
    supportedFilesystems = [ "ntfs" ];
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

  networking.hostName = "aurora";
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

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

  #fileSystems."/home/anas/audio" = {
  #  device = "10.0.0.2:/home/anas/audio";
  #  fsType = "nfs";
  #  options = [ "x-systemd.automount" "noauto" ];
  #};

  # fileSystems."/home/anas/.local/media/home.local" = {
  #   device = "192.168.2.10:/srv/nfs";
  #   fsType = "nfs";
  #   options = [ "x-systemd.automount" "noauto" ];
  # };
  # fileSystems."/home/anas/audio" = {
  #   device = "192.168.2.10:/srv/nfs/audio";
  #   fsType = "nfs";
  #   options = [ "x-systemd.automount" "noauto" ];
  # };
  # fileSystems."/home/anas/docs" = {
  #   device = "192.168.2.10:/srv/nfs/docs";
  #   fsType = "nfs";
  #   options = [ "x-systemd.automount" "noauto" ];
  # };
  # fileSystems."/home/anas/pics" = {
  #   device = "192.168.2.10:/srv/nfs/pics";
  #   fsType = "nfs";
  #   options = [ "x-systemd.automount" "noauto" ];
  # };
  # fileSystems."/home/anas/.local/var/games" =
  # {
  #   device = "192.168.2.10:/srv/nfs/.local/var/games";
  #   fsType = "nfs";
  #   options = [ "x-systemd.automount" "noauto" ];
  # };

  # nvidia - gpu
  powerManagement.enable = true;
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware = {
    enableRedistributableFirmware = true;

    facetimehd = {
      enable = true;
    };

    graphics = {
      enable = true;
    };

    pulseaudio = {
      enable = false;
    };

    video = {
    };
  };

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
      videoDrivers = ["nvidia"];
    };

    # gnome
    gnome = {
      # gnome-keyring
      gnome-keyring = {
        enable = true;
      };
      # gnome-online-accounts
      gnome-online-accounts = {
        enable = true;
      };
    };

    # nfs
    nfs = {
      server = {
        enable = true;
        exports = ''
          /export/aa 10.0.0.138(ro,fsid=0,no_subtree_check)
        '';
      };
    };

    # pipewire
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;
    };

    # smb
    #samba = {
    #  enable = true;
    #  securityType = "user";
    #  openFirewall = true;
    #  extraConfig = ''
    #    workgroup = WORKGROUP
    #    server string = aurora
    #    netbios name = aurora
    #    security = user
    #    #use sendfile = yes
    #    #max protocol = smb2
    #    # note: localhost is the ipv6 localhost ::1
    #    hosts allow = 10.0.0.138 127.0.0.1 localhost
    #    hosts deny = 0.0.0.0/0
    #    guest account = nobody
    #    map to guest = bad user
    #  '';
    #  shares = {
    #    #public = {
    #    #  path = "/mnt/Shares/Public";
    #    #  browseable = "yes";
    #    #  "read only" = "no";
    #    #  "guest ok" = "yes";
    #    #  "create mask" = "0644";
    #    #  "directory mask" = "0755";
    #    #  "force user" = "username";
    #    #  "force group" = "groupname";
    #    #};
    #    private = {
    #      path = "/export/aa";
    #      browseable = "yes";
    #      "read only" = "no";
    #      "guest ok" = "no";
    #      "create mask" = "0600";
    #      "directory mask" = "0700";
    #      "force user" = "anas";
    #      "force group" = "anas";
    #    };
    #  };
    #};
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
        #adwsteamgtk
        bibata-cursors
        comma
	mangohud
        eclipses.eclipse-sdk
        file
        flatpak
        git
        sushi
        monocraft
        neofetch
        neovim
        pantheon-tweaks
        protonup
        pulsemixer
        sbctl
        starship
        zsh
        inputs.nixvim.packages.${system}.default
      ])
      ++ (with pkgs.gnomeExtensions; [
        appindicator
        blur-my-shell
        color-picker
      ]);
    gnome.excludePackages =
      (with pkgs; [
        baobab
        epiphany
        evince
        file-roller
        geary
        gnome-calculator
        gnome-calendar
        gnome-characters
        gnome-clocks
        gnome-connections
        gnome-console
        gnome-contacts
        gnome-font-viewer
        gnome-logs
        gnome-maps
        gnome-music
        gnome-photos
        gnome-software
        gnome-system-monitor
        gnome-terminal
        gnome-text-editor
        gnome-tour
        gnome-weather
        loupe
        seahorse
        simple-scan
        snapshot
        totem
        yelp
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
    gamemode = {
      enable = true;
    };
    gamescope = {
      enable = true;
      capSysNice = true;
    };
    hyprland = {
      enable = true;
    };
    steam = {
      enable = true; 
      gamescopeSession = {
        enable = true;
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
  # pipewire - sound
  #services.pipewire = {
  #  enable = true;
  #  alsa.enable = true;
  #  alsa.support32Bit = true;
  #  pulse.enable = true;
  #  # If you want to use JACK applications, uncomment this
  #  jack.enable = true;
  #};

  # flatpak
  services.flatpak.enable = true;

  # blueman - bluetooth
  #services.blueman.enable = true;

  # dbus
  services.dbus = {
    enable = true;
    implementation = "broker";
  };

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
  system.stateVersion = "24.05"; # Did you read the comment?

}
