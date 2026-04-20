{
  self,
  ...
}:
{
  flake.nixosModules.nixos = { lib, pkgs, ... }: {
    ## nixpkgs
    nixpkgs = {
      hostPlatform = lib.mkDefault "x86_64-linux";
  
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

    fonts = {
      packages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.comic-code
        pkgs.noto-fonts
        pkgs.noto-fonts-cjk-sans
        pkgs.noto-fonts-color-emoji
      ];
    };
    
    console = {
      enable = true;
      packages = with pkgs; [ terminus_font ];
      keyMap = "us";

      colors = [
        "1e1e2e"
        "f38ba8"
        "a6e3a1"
        "f9e2af"
        "89b4fa"
        "f5c2e7"
        "94e2d5"
        "bac2de"
        "585b70"
        "f38ba8"
        "a6e3a1"
        "f9e2af"
        "89b4fa"
        "f5c2e7"
        "94e2d5"
        "a6adc8"
      ];
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
        self.packages.${pkgs.stdenv.hostPlatform.system}.comic-code
        self.packages.${pkgs.stdenv.hostPlatform.system}.tmux
        self.packages.${pkgs.stdenv.hostPlatform.system}.yazi
        self.packages.${pkgs.stdenv.hostPlatform.system}.kitty
        pkgs.fastfetch
        pkgs.ffmpeg
        pkgs.linux-firmware
        pkgs.sops
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
  
      # kmscon
      kmscon = {
        enable = true;
        hwRender = true;

        extraConfig = ''
          font-size=24
          palette=custom
          palette-black=30,30,46
          palette-red=243,139,168
          palette-green=166,227,161
          palette-yellow=249,226,175
          palette-blue=137,180,250
          palette-magenta=245,194,231
          palette-cyan=148,226,213
          palette-light-grey=186,194,222
          palette-dark-grey=88,91,112
          palette-light-red=243,139,168
          palette-light-green=166,227,161
          palette-light-yellow=249,226,175
          palette-light-blue=137,180,250
          palette-light-magenta=245,194,231
          palette-light-cyan=148,226,213
          palette-white=166,173,200
          palette-foreground=186,194,222
          palette-background=30,30,46
        '';

        fonts = [
          {
            name = "Comic Code";
            package = self.packages.${pkgs.stdenv.hostPlatform.system}.comic-code;
          }
        ];
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
