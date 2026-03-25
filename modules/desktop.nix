{
  self,
  self',
  inputs,
  ...
}:
{
  flake.nixosModules.desktop = { lib, pkgs, ... }: {
    home-manager = {
      users = {
        anas = {
          home = {
            pointerCursor = {
              dotIcons = {
                enable = false;
              };
            };
          };

          imports = [
            self.homeModules.stylix
            self.homeModules.email
            self.homeModules.desktop
          ];
        };
      };
    };

    ## boot
    boot = {
      consoleLogLevel = 0;
      initrd.verbose = false;

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
  
      plymouth = {
        enable = true;
        theme = "catppuccin-mocha";

        themePackages = [
          ( pkgs.catppuccin-plymouth.override { variant = "mocha"; })
        ];
      };

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
  
    ## environment
    environment = {
      pathsToLink = ["/share/applications" "/share/xdg-desktop-portal"];

      # system packages
      systemPackages = [
        pkgs.waylock
        pkgs.bibata-cursors
        pkgs.brightnessctl
      ];
    };

    ## networking
    networking = {
      useDHCP = lib.mkDefault true;
  
      # firewall
      firewall = {
        enable = true;
        allowPing = false;
      };
  
      # networkmanager
      networkmanager = {
        enable = true;
      };
    };
  
    ## hardware
    hardware = {
      graphics = {
        enable = true;
      };
    };
    
    powerManagement = {
      enable = true;
    };
    
    programs = {
      dsearch = {
        enable = true;

        systemd = {
          enable = true;
          target = "graphical-session.target";
        };
      };

      niri = {
        enable = true;
        package = self'.packages.niri;
      };
    };
    
    ## security
    security = {
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
      accounts-daemon = {
        enable = true;
      };

      displayManager = {
        dms-greeter = {
          enable = true;
          package = inputs.dms.packages.${pkgs.stdenv.hostPlatform.system}.default;
          quickshell.package = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default;

          compositor = {
            name = "niri";
          };

          configFiles = [
            "/home/anas/.local/etc/DankMaterialShell/settings.json"
            "/home/anas/.local/var/state/DankMaterialShell/session.json"
            "/home/anas/.local/var/cache/DankMaterialShell/dms-colors.json"
          ];

          logs = {
            save = true; 
            path = "/tmp/dms-greeter.log";
          };
        };
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

      upower = {
        enable = true;
      };

      tuned = {
        enable = true;
      };
    };
  };

  flake.homeModules.desktop = { config, pkgs, ... }: {
    imports = [
      inputs.dms.homeModules.dank-material-shell
    ];

    home.packages = with pkgs; [
      antigravity-fhs
      brave
      gamescope
      imv
      libnotify
      logseq
      mpv
      prismlauncher
      pulsemixer
      rbw
      steamguard-cli
      wl-clipboard
      wtype
      zathura
    ];

    services = {
      pass-secret-service = {
        enable = true;
        storePath = "${config.xdg.dataHome}/passwords";
      };
    };

    programs = {
      dank-material-shell = {
        enable = true;

        dgop.package = inputs.dgop.packages.${pkgs.stdenv.hostPlatform.system}.default;
        quickshell.package = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default;
        package = inputs.dms.packages.${pkgs.stdenv.hostPlatform.system}.default;


        enableAudioWavelength = true;
        enableCalendarEvents = true;
        #enableDynamicTheming = true;
        enableSystemMonitoring = true;
        #enableVPN = true;

        systemd = {
          enable = true;
          restartIfChanged = true;
        };

        settings = {
        };
        
        #session = {};
        #clipboardSettings = {};
      };

      password-store = {
        enable = true;
        package = pkgs.pass-wayland.withExtensions (ext: with ext; [ pass-otp pass-import pass-genphrase ]);

        settings = {
          PASSWORD_STORE_DIR = "${config.xdg.dataHome}/passwords";
          PASSWORD_STORE_CLIP_TIME = "10";
        };
      };

      qutebrowser = {
        enable = true;

        quickmarks = {
          nixsearch = "https://search.nixos.org/";
          hmsearch = "https://home-manager-options.extranix.com/?query=&release=master";
        };

        searchEngines = {
          g = "https://www.google.com/search?hl=en&q={}";
        };
      };
    };
  };
}
