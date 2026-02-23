{
  inputs,
  ...
}:
{
  flake.nixosModules.nixos = { lib, pkgs, ... }: {
    ## nixpkgs
    nixpkgs = {
      hostPlatform = lib.mkDefault "x86_64-linux";

      overlays = [
        # self.overlays.default
        inputs.niri.overlays.niri
      ];
  
      config = {
        # allow unfree packages
        allowUnfree = true;
  
        permittedInsecurePackages = [
          "broadcom-sta-6.30.223.271-59-6.12.69"
        ];
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
      packages = with pkgs; [ terminus_font ];
      keyMap = "us";
    };
  
    ## hardware
    hardware = {
      enableAllFirmware = true;
    };
  
    programs = {
      # gpg
      gnupg = {
        agent = {
          enable = true;
          #enableSSHSupport = true;
        };
      };
  
      # zsh
      zsh = {
        enable = true;
      };
    };
  
    system = {
      stateVersion = "24.11";
    };
  
    ## environment
    environment = {
      pathsToLink = ["/share/applications" "/share/xdg-desktop-portal"];
    
      # variables
      sessionVariables = rec {
        XDG_BIN_HOME = "$HOME/.local/bin";
        XDG_CACHE_HOME = "$HOME/.local/var/cache";
        XDG_CONFIG_HOME = "$HOME/.local/etc";
        XDG_DATA_HOME = "$HOME/.local/share";
        XDG_STATE_HOME = "$HOME/.local/var/state";
        ZDOTDIR = "$XDG_CONFIG_HOME/zsh";
  
        PATH = [
          "${XDG_BIN_HOME}"
        ];
      };
  
      # system packages
      systemPackages = [
        pkgs.brightnessctl
        pkgs.fastfetch
        pkgs.ffmpeg
        pkgs.linux-firmware
      ];
    };
  
    ## nix
    nix = {
      enable = true;
  
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
  
    ## security
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
    };
  
    ## services
    services = {
      # dbus
      dbus = {
        enable = true;
        implementation = "broker";
      };
  
      resolved = {
        enable = true;
      };

      tailscale = {
        enable = true;
        useRoutingFeatures = "both";
      };
    };
    
    users = {
      defaultUserShell = pkgs.zsh;
    };
  };
}
