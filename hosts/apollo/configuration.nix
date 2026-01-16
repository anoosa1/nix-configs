{
  inputs,
  pkgs,
  ...
}:
{
  ## boot
  boot = {
    kernelPackages = pkgs.linuxPackages_6_12;
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
        "broadcom-sta-6.30.223.271-59-6.12.63"
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
        niri = {
          prettyName = "Niri";
          comment = "Niri (UWSM)";
          binPath = "/run/current-system/sw/bin/niri";
        };
      };
    };
  };

  system = {
    stateVersion = "24.11";
  };
}
