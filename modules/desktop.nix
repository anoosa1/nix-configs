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

        extraConfig = ''
          palette = {
            "rosewater": "#f5e0dc",
            "flamingo": "#f2cdcd",
            "pink": "#f5c2e7",
            "mauve": "#cba6f7",
            "red": "#f38ba8",
            "maroon": "#eba0ac",
            "peach": "#fab387",
            "yellow": "#f9e2af",
            "green": "#a6e3a1",
            "teal": "#94e2d5",
            "sky": "#89dceb",
            "sapphire": "#74c7ec",
            "blue": "#89b4fa",
            "lavender": "#b4befe",
            "text": "#cdd6f4",
            "subtext1": "#bac2de",
            "subtext0": "#a6adc8",
            "overlay2": "#9399b2",
            "overlay1": "#7f849c",
            "overlay0": "#6c7086",
            "surface2": "#585b70",
            "surface1": "#45475a",
            "surface0": "#313244",
            "base": "#1e1e2e",
            "mantle": "#181825",
            "crust": "#11111b",
          }

          c.colors.completion.category.bg = "${self.theme.base00}"
          c.colors.completion.category.border.bottom = "${self.theme.base01}"
          c.colors.completion.category.border.top = palette["overlay2"]
          c.colors.completion.category.fg = "${self.theme.base0B}"
          if samecolorrows:
            c.colors.completion.even.bg = "${self.theme.base01}"
            c.colors.completion.odd.bg = c.colors.completion.even.bg
          else:
            c.colors.completion.even.bg = "${self.theme.base01}"
            c.colors.completion.odd.bg = palette["crust"]
          c.colors.completion.fg = palette["subtext0"]
          c.colors.completion.item.selected.bg = "${self.theme.base04}"
          c.colors.completion.item.selected.border.bottom = "${self.theme.base04}"
          c.colors.completion.item.selected.border.top = "${self.theme.base04}"
          c.colors.completion.item.selected.fg = "${self.theme.base05}"
          c.colors.completion.item.selected.match.fg = "${self.theme.base06}"
          c.colors.completion.match.fg = "${self.theme.base05}"
          c.colors.completion.scrollbar.bg = palette["crust"]
          c.colors.completion.scrollbar.fg = "${self.theme.base04}"
          c.colors.downloads.bar.bg = "${self.theme.base00}"
          c.colors.downloads.error.bg = "${self.theme.base00}"
          c.colors.downloads.start.bg = "${self.theme.base00}"
          c.colors.downloads.stop.bg = "${self.theme.base00}"
          c.colors.downloads.error.fg = palette["red"]
          c.colors.downloads.start.fg = "${self.theme.base0D}"
          c.colors.downloads.stop.fg = "${self.theme.base0B}"
          c.colors.downloads.system.fg = "none"
          c.colors.downloads.system.bg = "none"
          c.colors.hints.bg = "${self.theme.base09}"
          c.colors.hints.fg = "${self.theme.base01}"
          c.hints.border = "1px solid " + "${self.theme.base01}"
          c.colors.hints.match.fg = palette["subtext1"]
          c.colors.keyhint.bg = "${self.theme.base01}"
          c.colors.keyhint.fg = "${self.theme.base05}"
          c.colors.keyhint.suffix.fg = palette["subtext1"]
          c.colors.messages.error.bg = palette["overlay0"]
          c.colors.messages.info.bg = palette["overlay0"]
          c.colors.messages.warning.bg = palette["overlay0"]
          c.colors.messages.error.border = "${self.theme.base01}"
          c.colors.messages.info.border = "${self.theme.base01}"
          c.colors.messages.warning.border = "${self.theme.base01}"
          c.colors.messages.error.fg = palette["red"]
          c.colors.messages.info.fg = "${self.theme.base05}"
          c.colors.messages.warning.fg = "${self.theme.base09}"
          c.colors.prompts.bg = "${self.theme.base01}"
          c.colors.prompts.border = "1px solid " + palette["overlay0"]
          c.colors.prompts.fg = "${self.theme.base05}"
          c.colors.prompts.selected.bg = "${self.theme.base04}"
          c.colors.prompts.selected.fg = "${self.theme.base06}"
          c.colors.statusbar.normal.bg = "${self.theme.base00}"
          c.colors.statusbar.insert.bg = palette["crust"]
          c.colors.statusbar.command.bg = "${self.theme.base00}"
          c.colors.statusbar.caret.bg = "${self.theme.base00}"
          c.colors.statusbar.caret.selection.bg = "${self.theme.base00}"
          c.colors.statusbar.progress.bg = "${self.theme.base00}"
          c.colors.statusbar.passthrough.bg = "${self.theme.base00}"
          c.colors.statusbar.normal.fg = "${self.theme.base05}"
          c.colors.statusbar.insert.fg = "${self.theme.base06}"
          c.colors.statusbar.command.fg = "${self.theme.base05}"
          c.colors.statusbar.passthrough.fg = "${self.theme.base09}"
          c.colors.statusbar.caret.fg = "${self.theme.base09}"
          c.colors.statusbar.caret.selection.fg = "${self.theme.base09}"
          c.colors.statusbar.url.error.fg = palette["red"]
          c.colors.statusbar.url.fg = "${self.theme.base05}"
          c.colors.statusbar.url.hover.fg = palette["sky"]
          c.colors.statusbar.url.success.http.fg = "${self.theme.base0C}"
          c.colors.statusbar.url.success.https.fg = "${self.theme.base0B}"
          c.colors.statusbar.url.warn.fg = "${self.theme.base0A}"
          c.colors.statusbar.private.bg = "${self.theme.base01}"
          c.colors.statusbar.private.fg = palette["subtext1"]
          c.colors.statusbar.command.private.bg = "${self.theme.base00}"
          c.colors.statusbar.command.private.fg = palette["subtext1"]
          c.colors.tabs.bar.bg = palette["crust"]
          c.colors.tabs.even.bg = "${self.theme.base04}"
          c.colors.tabs.odd.bg = "${self.theme.base03}"
          c.colors.tabs.even.fg = palette["overlay2"]
          c.colors.tabs.odd.fg = palette["overlay2"]
          c.colors.tabs.indicator.error = palette["red"]
          ## Color gradient interpolation system for the tab indicator.
          ## Valid values:
          ##	 - rgb: Interpolate in the RGB color system.
          ##	 - hsv: Interpolate in the HSV color system.
          ##	 - hsl: Interpolate in the HSL color system.
          ##	 - none: Don't show a gradient.
          c.colors.tabs.indicator.system = "none"
          c.colors.tabs.selected.even.bg = "${self.theme.base00}"
          c.colors.tabs.selected.odd.bg = "${self.theme.base00}"
          c.colors.tabs.selected.even.fg = "${self.theme.base05}"
          c.colors.tabs.selected.odd.fg = "${self.theme.base05}"
          c.colors.contextmenu.menu.bg = "${self.theme.base00}"
          c.colors.contextmenu.menu.fg = "${self.theme.base05}"
          c.colors.contextmenu.disabled.bg = "${self.theme.base01}"
          c.colors.contextmenu.disabled.fg = palette["overlay0"]
          c.colors.contextmenu.selected.bg = palette["overlay0"]
          c.colors.contextmenu.selected.fg = "${self.theme.base06}"
        '';
      };
    };
  };
}
