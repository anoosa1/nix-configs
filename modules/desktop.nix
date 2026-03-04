{
  self,
  inputs,
  ...
}:
{
  flake.nixosModules.desktop = { lib, pkgs, ... }: {
    imports = [
      inputs.niri.nixosModules.niri
    ];

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
      niri = {
        enable = true;
      };
    
      # uwsm
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
            package = self.packages.${pkgs.system}.comic-code;
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
    
      greetd = {
        enable = true;
        useTextGreeter = true;

        settings = {
          default_session = {
            command = "${pkgs.tuigreet}/bin/tuigreet --time";
            user = "greeter";
          };
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
      inputs.noctalia.homeModules.default
    ];

    home.packages = with pkgs; [
      self.packages.${pkgs.system}.bookmarks
      antigravity-fhs
      brave
      gamescope
      google-chrome
      imv
      kitty
      libnotify
      logseq
      prismlauncher
      rbw
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
      bemenu = {
        enable = true;

        settings = {
          ignorecase = true;
          fb = "#1e1e2e";
          ff = "#cdd6f4";
          nb = "#1e1e2e";
          nf = "#cdd6f4";
          tb = "#1e1e2e";
          hb = "#1e1e2e";
          tf = "#f38ba8";
          hf = "#f9e2af";
          af = "#cdd6f4";
          ab = "#1e1e2e";
        };
      };

      kitty = {
        enable = true;

        font = {
          name = "Comic Code";
          size = 16;
        };

        shellIntegration = {
          enableZshIntegration = true;
        };

        settings = {
          #background_opacity = "0.8";
          scrollback_lines = 5000;
          window_padding_width = 10;
      
          background = "#1d2021";
          foreground = "#ebdbb2";
          selection_foreground = "#ebdbb2";
          selection_background = "#d65d0e";
          cursor = "#bdae93";
          cursor_text_color = "#665c54";
          url_color = "#458588";
      
          active_tab_foreground = "#eeeeee";
          active_tab_background = "#d65d0e";
          inactive_tab_foreground = "#ebdbb2";
          inactive_tab_background = "#171a1a";
      
          color0 = "#3c3836";
          color1 = "#cc241d";
          color2 = "#98971a";
          color3 = "#d79921";
          color4 = "#458588";
          color5 = "#b16286";
          color6 = "#689d6a";
          color7 = "#a89984";
          color8 = "#928374";
          color9 = "#fb4934";
          color10 = "#b8bb26";
          color11 = "#fabd2f";
          color12 = "#83a598";
          color13 = "#d3869b";
          color14 = "#8ec07c";
          color15 = "#fbf1c7";
        };
      };

      niri = {
        settings = {
          screenshot-path = "~/pics/screenshots/Screenshot_%Y%m%d-%H%M%S.png";
          prefer-no-csd = true;

          debug = {
            honor-xdg-activation-with-invalid-serial = [];
          };

          animations = {
            slowdown = 0.7;
          };

          cursor = {
            hide-after-inactive-ms = 3000;
            hide-when-typing = true;
          };

          environment = {
            DISPLAY = ":0";
          };

          hotkey-overlay = {
            skip-at-startup = true;
          };

          input = {
            keyboard = {
              numlock = true;
              repeat-delay = 300;
              repeat-rate = 50;


              xkb = {
                layout = "us";
              };
            };

            focus-follows-mouse = {
              enable = true;
            };

            mouse = {
              accel-profile = "flat";
              accel-speed = -0.3;
            };
          };

          outputs = {
            "HDMI-A-1" = {
              variable-refresh-rate = true;

              mode = {
                width = 1920;
                height = 1080;
                refresh = 100.0;
              };
            };
          };

          spawn-at-startup = [
            { command = [ "dbus-update-activation-environment" "--systemd" "WAYLAND_DISPLAY" "XDG_CURRENT_DESKTOP" "DISPLAY" ]; }
            { command = [ "noctalia-shell" ]; }
          ];

          binds = with config.lib.niri.actions; {
            "Mod+Backspace".action.spawn = [ "noctalia-shell" "ipc" "call" "lockScreen" "lock" ];
            "Mod+Shift+Backspace".action = quit;
            "Mod+Ctrl+Backspace".action = power-off-monitors;

            "Mod+D".action.spawn = "bemenu-run";
            "Mod+Shift+D".action.spawn = [ "noctalia-shell" "ipc" "call" "launcher" "toggle" ];
            "Mod+R".action.spawn = "kitty -e lf";
            "Mod+Return".action.spawn = "kitty";
            "Mod+Shift+Slash".action = show-hotkey-overlay;

            "Mod+Shift+B".action = center-column;
            "Mod+B".action = spawn "battery.sh";
            "Mod+N".action = spawn "logseq";
            "Mod+Ctrl+C".action = center-visible-columns;

            "Mod+C".action = spawn "bookmarks.sh" "--save";
            "Mod+Shift+C".action = spawn "bookmarks.sh" "--copy";
            "Mod+V".action = spawn "bookmarks.sh" "--type";

            "Mod+F".action = maximize-column;
            "Mod+Shift+F".action = fullscreen-window;
            "Mod+Ctrl+F".action = expand-column-to-available-width;

            "Mod+W".action.spawn = "brave";
            "Mod+Q" = {
              action = close-window;
              repeat = false;
            };

            "Mod+Shift+Return" = {
              action = toggle-overview;
              repeat = false;
            };

            "Mod+Alt+Return" = {
              action = toggle-overview;
              repeat = false;
            };

            "Mod+Left".action = focus-monitor-left;
            "Mod+Down".action = focus-monitor-down;
            "Mod+Up".action = focus-monitor-up;
            "Mod+Right".action = focus-monitor-right;
            "Mod+Shift+Left".action = move-column-to-monitor-left;
            "Mod+Shift+Down".action = move-column-to-monitor-down;
            "Mod+Shift+Up".action = move-column-to-monitor-up;
            "Mod+Shift+Right".action = move-column-to-monitor-right;

            "Mod+H".action = set-column-width "-10%";
            "Mod+L".action = set-column-width "+10%";
            "Mod+Shift+H".action = set-window-height "+10%";
            "Mod+Shift+L".action = set-window-height "-10%";
            "Mod+Y".action = switch-preset-column-width;
            "Mod+Shift+Y".action = toggle-column-tabbed-display;

            "Mod+Shift+Space".action = toggle-window-floating;
            "Mod+Escape" = {
              allow-inhibiting = false;
              action = toggle-keyboard-shortcuts-inhibit;
            };

            "Print".action.screenshot = [];
            "Mod+XF86AudioRaiseVolume".action.screenshot = [];
            "Ctrl+Print".action.screenshot-screen = [];
            "Shift+Print".action.screenshot-window = [];

            "Mod+1".action.focus-workspace = 1;
            "Mod+2".action.focus-workspace = 2;
            "Mod+3".action.focus-workspace = 3;
            "Mod+4".action.focus-workspace = 4;
            "Mod+5".action.focus-workspace = 5;
            "Mod+6".action.focus-workspace = 6;
            "Mod+7".action.focus-workspace = 7;
            "Mod+8".action.focus-workspace = 8;
            "Mod+9".action.focus-workspace = 9;
            "Mod+Shift+1".action.move-column-to-workspace = 1;
            "Mod+Shift+2".action.move-column-to-workspace = 2;
            "Mod+Shift+3".action.move-column-to-workspace = 3;
            "Mod+Shift+4".action.move-column-to-workspace = 4;
            "Mod+Shift+5".action.move-column-to-workspace = 5;
            "Mod+Shift+6".action.move-column-to-workspace = 6;
            "Mod+Shift+7".action.move-column-to-workspace = 7;
            "Mod+Shift+8".action.move-column-to-workspace = 8;
            "Mod+Shift+9".action.move-column-to-workspace = 9;

            "XF86MonBrightnessUp" = {
              action = spawn "brightnessctl" "--class=backlight" "set" "+10%";
              allow-when-locked = true;
            };
            "XF86MonBrightnessDown" = {
              action = spawn "brightnessctl" "--class=backlight" "set" "10%-";
              allow-when-locked = true;
            };
            "XF86KbdBrightnessUp" = {
              action = spawn "brightnessctl" "--device=smc::kbd_backlight" "set" "+10%";
              allow-when-locked = true;
            };
            "XF86KbdBrightnessDown" = {
              action = spawn "brightnessctl" "--device=smc::kbd_backlight" "set" "10%-";
              allow-when-locked = true;
            };
            #"XF86AudioRaiseVolume" = {
            #  action = spawn "pulsemixer" "--change-volume" "+5";
            #  allow-when-locked = true;
            #};
            #"XF86AudioLowerVolume" = {
            #  action = spawn "pulsemixer" "--change-volume" "-5";
            #  allow-when-locked = true;
            #};
            #"XF86AudioMute" = {
            #  action = spawn "pulsemixer" "--toggle-mute";
            #  allow-when-locked = true;
            #};
            "XF86AudioLowerVolume".action.spawn = [ "noctalia-shell" "ipc" "call" "volume" "decrease" ];
            "XF86AudioRaiseVolume".action.spawn = [ "noctalia-shell" "ipc" "call" "volume" "increase" ];
            "XF86AudioMute".action.spawn = [ "noctalia-shell" "ipc" "call" "volume" "muteOutput" ];

            "Mod+J".action = focus-column-left-or-last;
            "Mod+K".action = focus-column-right-or-first;
            "Mod+Shift+J".action = move-column-left-or-to-monitor-left;
            "Mod+Shift+K".action = move-column-right-or-to-monitor-right;
            "Mod+Alt+J".action = consume-or-expel-window-left;
            "Mod+Alt+K".action = consume-or-expel-window-right;
            "Mod+Ctrl+J".action = focus-window-or-workspace-down;
            "Mod+Ctrl+K".action = focus-window-or-workspace-up;
            "Mod+Ctrl+Shift+J".action = move-window-down-or-to-workspace-down;
            "Mod+Ctrl+Shift+K".action = move-window-up-or-to-workspace-up;
          };

          window-rules = [
            {
              geometry-corner-radius = {
                bottom-left = 20.0;
                bottom-right = 20.0;
                top-left = 20.0;
                top-right = 20.0;
              };
              clip-to-geometry = true;
            }
          ];

          layout = {
            gaps = 0;

            border = {
              enable = true;
              width = 3;

              active = {
                color = "#F4B8E4";
              };

              inactive = {
                color = "#626880";
              };
            };

            default-column-width = {
              proportion = 0.5;
            };

            preset-column-widths = [
              { proportion = 1. / 2.; }
              { proportion = 2. / 3.; }
            ];

            focus-ring = {
              width = 1;
            };

            struts = {
              bottom = 0;
              left = 0;
              right = 0;
              top = 0;
            };
          };
        };
      };

      noctalia-shell = {
        enable = true;

        settings = {
          appLauncher = {
            autoPasteClipboard = true;
            enableClipboardHistory = true;
            showCategories = false;
            terminalCommand = "kitty -e";

            pinnedApps = [
              "Logseq"
              "kitty"
              "org.qutebrowser.qutebrowser"
            ];
          };

          audio = {
            volumeOverdrive = false;
            preferredPlayer = "mpv";
            #volumeFeedback = false;
            #volumeFeedbackSoundFile = "";
          };

          bar = {
            position = "top";
            showOutline = true;
            showCapsule = true;
            widgetSpacing = 6;
            contentPadding = 4;
            outerCorners = false;
            hideOnOverview = true;
            displayMode = "auto_hide";
            autoShowDelay = 100;
            showOnWorkspaceSwitch = true;
            widgets = {
              left = [
                {
                  colorizeDistroLogo = false;
                  colorizeSystemIcon = "none";
                  enableColorization = true;
                  icon = "noctalia";
                  id = "ControlCenter";
                  useDistroLogo = true;
                }
                {
                  id = "Workspace";
                  pillSize = 0.5;
                }
                {
                  colorizeIcons = true;
                  hideMode = "hidden";
                  id = "Taskbar";
                }
              ];
              center = [
                {
                  colorizeIcons = true;
                  hideMode = "hidden";
                  id = "ActiveWindow";
                }
                {
                  hideMode = "hidden";
                  hideWhenIdle = false;
                  id = "MediaMini";
                  panelShowAlbumArt = true;
                  panelShowVisualizer = true;
                  scrollingMode = "hover";
                  showAlbumArt = true;
                  showArtistFirst = false;
                  showProgressRing = true;
                  showVisualizer = true;
                }
              ];
              right = [
                {
                  displayMode = "alwaysShow";
                  id = "Volume";
                  middleClickCommand = "pulsemixer --toggle-mute";
                }
                {
                  displayMode = "alwaysShow";
                  id = "Microphone";
                  middleClickCommand = "pulsemixer --id source-53 --toggle-mute";
                }
                {
                  displayMode = "alwaysShow";
                  id = "Brightness";
                }
                {
                  id = "Network";
                }
                {
                  displayMode = "icon-always";
                  id = "Battery";
                  showNoctaliaPerformance = true;
                  showPowerProfiles = true;
                }
                {
                  hideWhenZero = false;
                  hideWhenZeroUnread = false;
                  iconColor = "none";
                  id = "NotificationHistory";
                }
                {
                  colorizeIcons = true;
                  drawerEnabled = true;
                  id = "Tray";
                }
                {
                  formatHorizontal = "HH:mm:ss";
                  id = "Clock";
                }
                {
                  iconColor = "error";
                  id = "SessionMenu";
                }
              ];
            };
          };

          brightness = {
            enforceMinimum = false;
          };

          colorSchemes = {
            useWallpaperColors = false;
            predefinedScheme = "Catppuccin";
            darkMode = true;
          };

          controlCenter = {
            shortcuts = {
              left = [
                {
                  id = "Network";
                }
                {
                  id = "AirplaneMode";
                }
                {
                  id = "WallpaperSelector";
                }
                {
                  id = "Notifications";
                }
              ];

              right = [
                {
                  id = "NoctaliaPerformance";
                }
                {
                  id = "PowerProfile";
                }
                {
                  id = "KeepAwake";
                }
                {
                  id = "NightLight";
                }
              ];
            };
          };

          desktopWidgets = {
            enabled = false;
          };

          dock = {
            enabled = false;
          };

          general = {
            animationSpeed = 1.75;
            avatarImage = "/home/anas/pics/saved\ pics/avatars/433397787_2224237877924749_1519880664654280686_n.jpg";
            clockFormat = "hh:mm:ss";
            clockStyle = "custom";
            dimmerOpacity = 0.1;
            enableShadows = false;
            lockOnSuspend = true;
            lockScreenAnimations = true;
            lockScreenBlur = 0.2;
            showChangelogOnStartup = true;
            showHibernateOnLockScreen = true;
            showSessionButtonsOnLockScreen = true;
          };

          location = {
            name = "Milton, Ontario";
            showWeekNumberInCalendar = true;
          };

          nightLight = {
            enabled = true;
            autoSchedule = true;
            nightTemp = "1000";
          };

          notifications = {
            clearDismissed = false;
            density = "compact";
            enableMarkdown = true;
          };

          osd = {
            autoHideMs = 1000;
          };

          sessionMenu = {
            enableCountdown = false;
            largeButtonsStyle = false;
          };

          ui = {
            fontDefault = "Comic Code";
            fontFixed = "Comic Code";
            panelBackgroundOpacity = 0.75;
          };

          wallpaper = {
            directory = "/home/anas/pics/saved pics/wallpapers";
            overviewBlur = 0;
            overviewEnabled = true;
            overviewTint = 0.1;
          };
        };
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
