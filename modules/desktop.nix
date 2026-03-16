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
      niri = {
        enable = true;
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

      displayManager = {
        dms-greeter = {
          compositor.name = "niri";
          configHome = "/home/anas";
          enable = true;
          package = inputs.dms.packages.${pkgs.stdenv.hostPlatform.system}.default;
          quickshell.package = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default;
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
    
      #greetd = {
      #  enable = true;
      #  useTextGreeter = true;

      #  settings = {
      #    default_session = {
      #      command = "${pkgs.tuigreet}/bin/tuigreet --time";
      #      user = "greeter";
      #    };
      #  };
      #};

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
      inputs.danksearch.homeModules.default
      inputs.dms.homeModules.dank-material-shell
    ];

    home.packages = with pkgs; [
      self.packages.${pkgs.stdenv.hostPlatform.system}.bookmarks
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
          ];

          binds = with config.lib.niri.actions; {
            "Mod+Backspace".action.spawn = [ "dms" "ipc" "lock" "lock" ];
            "Mod+Shift+Backspace".action.spawn = [ "dms" "ipc" "powermenu" "toggle" ];
            "Mod+Ctrl+Backspace".action = power-off-monitors;

            "Mod+D".action.spawn = "bemenu-run";
            "Mod+Shift+D".action.spawn = [ "dms" "ipc" "spotlight" "toggle" ];
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
            "XF86AudioRaiseVolume" = {
              action = spawn "pulsemixer" "--change-volume" "+5";
              allow-when-locked = true;
            };
            "XF86AudioLowerVolume" = {
              action = spawn "pulsemixer" "--change-volume" "-5";
              allow-when-locked = true;
            };
            "XF86AudioMute" = {
              action = spawn "pulsemixer" "--toggle-mute";
              allow-when-locked = true;
            };

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

      dsearch = {
        enable = true;
      };

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
          currentThemeName = "custom";
          currentThemeCategory = "registry";
          customThemeFile = "/home/anas/.config/DankMaterialShell/themes/catppuccin/theme.json";
          
          registryThemeVariants = {
            catppuccin = {
              dark = {
                flavor = "mocha";
                accent = "pink";
              };
            };
          };
          
          matugenScheme = "scheme-tonal-spot";
          runUserMatugenTemplates = true;
          matugenTargetMonitor = "";
          popupTransparency = 1;
          dockTransparency = 1;
          widgetBackgroundColor = "sc";
          widgetColorMode = "colorful";
          controlCenterTileColorMode = "primary";
          buttonColorMode = "primary";
          cornerRadius = 16;
          firstDayOfWeek = -1;
          use24HourClock = true;
          showSeconds = true;
          padHours12Hour = false;
          useFahrenheit = false;
          windSpeedUnit = "kmh";
          nightModeEnabled = false;
          animationSpeed = 1;
          customAnimationDuration = 500;
          syncComponentAnimationSpeeds = true;
          popoutAnimationSpeed = 1;
          popoutCustomAnimationDuration = 150;
          modalAnimationSpeed = 1;
          modalCustomAnimationDuration = 150;
          enableRippleEffects = true;
          m3ElevationEnabled = true;
          m3ElevationIntensity = 12;
          m3ElevationOpacity = 30;
          m3ElevationColorMode = "default";
          m3ElevationLightDirection = "top";
          m3ElevationCustomColor = "#000000";
          modalElevationEnabled = true;
          popoutElevationEnabled = true;
          barElevationEnabled = false;
          
          showPrivacyButton = true;
          privacyShowMicIcon = true;
          privacyShowCameraIcon = true;
          privacyShowScreenShareIcon = true;
          
          controlCenterWidgets = [
            { id = "volumeSlider"; enabled = true; width = 50; }
            { id = "brightnessSlider"; enabled = true; width = 50; }
            { id = "wifi"; enabled = true; width = 50; }
            { id = "bluetooth"; enabled = true; width = 50; }
            { id = "audioOutput"; enabled = true; width = 50; }
            { id = "audioInput"; enabled = true; width = 50; }
            { id = "nightMode"; enabled = true; width = 50; }
            { id = "darkMode"; enabled = true; width = 50; }
          ];
          
          showWorkspaceIndex = false;
          showWorkspaceName = false;
          showWorkspacePadding = false;
          workspaceScrolling = false;
          showWorkspaceApps = false;
          workspaceDragReorder = true;
          maxWorkspaceIcons = 3;
          workspaceAppIconSizeOffset = 0;
          groupWorkspaceApps = true;
          workspaceFollowFocus = false;
          showOccupiedWorkspacesOnly = true;
          reverseScrolling = false;
          dwlShowAllTags = false;
          workspaceActiveAppHighlightEnabled = false;
          workspaceColorMode = "default";
          workspaceOccupiedColorMode = "none";
          workspaceUnfocusedColorMode = "default";
          workspaceUrgentColorMode = "default";
          workspaceFocusedBorderEnabled = false;
          workspaceFocusedBorderColor = "secondary";
          workspaceFocusedBorderThickness = 2;
          workspaceNameIcons = {};
          waveProgressEnabled = true;
          scrollTitleEnabled = true;
          audioVisualizerEnabled = true;
          audioScrollMode = "volume";
          audioWheelScrollAmount = 5;
          clockCompactMode = false;
          focusedWindowCompactMode = false;
          runningAppsCompactMode = true;
          barMaxVisibleApps = 0;
          barMaxVisibleRunningApps = 0;
          barShowOverflowBadge = true;
          appsDockHideIndicators = false;
          appsDockColorizeActive = false;
          appsDockActiveColorMode = "primary";
          appsDockEnlargeOnHover = false;
          appsDockEnlargePercentage = 125;
          appsDockIconSizePercentage = 100;
          keyboardLayoutNameCompactMode = false;
          runningAppsCurrentWorkspace = true;
          runningAppsGroupByApp = false;
          runningAppsCurrentMonitor = false;
          
          appIdSubstitutions = [
            {
              pattern = "^steam_app_(\\d+)$";
              replacement = "steam_icon_$1";
              type = "regex";
            }
          ];
          
          centeringMode = "index";
          clockDateFormat = "";
          lockDateFormat = "";
          greeterRememberLastSession = true;
          greeterRememberLastUser = true;
          greeterEnableFprint = false;
          greeterEnableU2f = false;
          greeterWallpaperPath = "/home/anas/pics/saved pics/wallpapers/wheat.png";
          greeterUse24HourClock = true;
          greeterShowSeconds = true;
          greeterPadHours12Hour = false;
          greeterLockDateFormat = "";
          greeterFontFamily = "Comic Code";
          greeterWallpaperFillMode = "";
          mediaSize = 1;
          appLauncherViewMode = "list";
          spotlightModalViewMode = "list";
          browserPickerViewMode = "grid";
          browserUsageHistory = {};
          appPickerViewMode = "grid";
          filePickerUsageHistory = {};
          sortAppsAlphabetically = false;
          appLauncherGridColumns = 7;
          spotlightCloseNiriOverview = true;
          
          spotlightSectionViewModes = {
            apps = "list";
          };
          
          appDrawerSectionViewModes = {};
          niriOverviewOverlayEnabled = true;
          dankLauncherV2Size = "compact";
          dankLauncherV2BorderEnabled = false;
          dankLauncherV2BorderThickness = 2;
          dankLauncherV2BorderColor = "primary";
          dankLauncherV2ShowFooter = true;
          dankLauncherV2UnloadOnClose = true;
          useAutoLocation = false;
          weatherEnabled = true;
          networkPreference = "auto";
          iconTheme = "System Default";
          
          cursorSettings = {
            theme = "Bibata-Modern-Ice";
            size = 24;
            niri = {
              hideWhenTyping = false;
              hideAfterInactiveMs = 0;
            };
          };
          
          launcherLogoMode = "os";
          launcherLogoCustomPath = "";
          launcherLogoColorOverride = "primary";
          launcherLogoColorInvertOnMode = false;
          launcherLogoBrightness = 0.5;
          launcherLogoContrast = 1;
          launcherLogoSizeOffset = 0;
          fontFamily = "Comic Code";
          monoFontFamily = "Comic Code";
          fontWeight = 400;
          fontScale = 1;
          notepadUseMonospace = true;
          notepadFontFamily = "";
          notepadFontSize = 14;
          notepadShowLineNumbers = false;
          notepadTransparencyOverride = -1;
          notepadLastCustomTransparency = 0.7;
          soundsEnabled = true;
          useSystemSoundTheme = false;
          soundNewNotification = true;
          soundVolumeChanged = true;
          soundPluggedIn = true;
          acMonitorTimeout = 0;
          acLockTimeout = 0;
          acSuspendTimeout = 0;
          acSuspendBehavior = 2;
          acProfileName = "";
          batteryMonitorTimeout = 0;
          batteryLockTimeout = 0;
          batterySuspendTimeout = 0;
          batterySuspendBehavior = 0;
          batteryProfileName = "";
          batteryChargeLimit = 100;
          lockBeforeSuspend = true;
          loginctlLockIntegration = true;
          fadeToLockEnabled = true;
          fadeToLockGracePeriod = 5;
          fadeToDpmsEnabled = true;
          fadeToDpmsGracePeriod = 5;
          launchPrefix = "";
          brightnessDevicePins = {};
          wifiNetworkPins = {};
          bluetoothDevicePins = {};
          audioInputDevicePins = {};
          audioOutputDevicePins = {};
          gtkThemingEnabled = false;
          qtThemingEnabled = false;
          syncModeWithPortal = true;
          terminalsAlwaysDark = false;
          runDmsMatugenTemplates = false;
          
          showDock = false;
          notificationOverlayEnabled = false;
          notificationPopupShadowEnabled = true;
          notificationPopupPrivacyMode = false;
          modalDarkenBackground = true;
          lockScreenShowPowerActions = true;
          lockScreenShowSystemIcons = true;
          lockScreenShowTime = true;
          lockScreenShowDate = true;
          lockScreenShowProfileImage = true;
          lockScreenShowPasswordField = true;
          lockScreenShowMediaPlayer = true;
          lockScreenPowerOffMonitorsOnLock = false;
          lockAtStartup = false;
          enableFprint = false;
          maxFprintTries = 15;
          enableU2f = false;
          u2fMode = "or";
          lockScreenActiveMonitor = "all";
          lockScreenInactiveColor = "#000000";
          lockScreenNotificationMode = 2;
          lockScreenVideoEnabled = false;
          lockScreenVideoPath = "";
          lockScreenVideoCycling = false;
          hideBrightnessSlider = false;
          notificationTimeoutLow = 5000;
          notificationTimeoutNormal = 5000;
          notificationTimeoutCritical = 0;
          notificationCompactMode = false;
          notificationPopupPosition = 3;
          notificationAnimationSpeed = 1;
          notificationCustomAnimationDuration = 400;
          notificationHistoryEnabled = true;
          notificationHistoryMaxCount = 200;
          notificationHistoryMaxAgeDays = 0;
          notificationHistorySaveLow = true;
          notificationHistorySaveNormal = true;
          notificationHistorySaveCritical = true;
          notificationRules = [];
          notificationFocusedMonitor = false;
          osdAlwaysShowValue = true;
          osdPosition = 5;
          osdVolumeEnabled = true;
          osdMediaVolumeEnabled = true;
          osdMediaPlaybackEnabled = true;
          osdBrightnessEnabled = true;
          osdIdleInhibitorEnabled = true;
          osdMicMuteEnabled = true;
          osdCapsLockEnabled = true;
          osdPowerProfileEnabled = false;
          osdAudioOutputEnabled = true;
          powerActionConfirm = true;
          powerActionHoldDuration = 0.5;
          
          powerMenuActions = [
            "reboot"
            "logout"
            "poweroff"
            "lock"
            "suspend"
            "hibernate"
            "restart"
          ];
          
          powerMenuDefaultAction = "logout";
          powerMenuGridLayout = false;
          customPowerActionLock = "";
          customPowerActionLogout = "";
          customPowerActionSuspend = "";
          customPowerActionHibernate = "";
          customPowerActionReboot = "";
          customPowerActionPowerOff = "";
          updaterHideWidget = false;
          updaterUseCustomCommand = false;
          updaterCustomCommand = "";
          updaterTerminalAdditionalParams = "";
          displayNameMode = "system";
          screenPreferences = {};
          showOnLastDisplay = {};
          
          niriOutputSettings = {
            "HDMI-A-1" = {
              vrrOnDemand = null;
            };
          };
          
          barConfigs = [
            {
              id = "default";
              name = "Main Bar";
              enabled = true;
              position = 1;
              screenPreferences = [ "all" ];
              showOnLastDisplay = true;
              leftWidgets = [ "launcherButton" "workspaceSwitcher" "focusedWindow" ];
              centerWidgets = [ "music" "clock" "weather" ];
              rightWidgets = [
                "systemTray"
                "clipboard"
                "notificationButton"
                "battery"
                "controlCenterButton"
                { id = "powerMenuButton"; enabled = true; }
              ];
              spacing = 4;
              innerPadding = 4;
              bottomGap = 0;
              transparency = 1;
              widgetTransparency = 1;
              squareCorners = false;
              noBackground = false;
              maximizeWidgetIcons = false;
              maximizeWidgetText = false;
              removeWidgetPadding = false;
              widgetPadding = 8;
              gothCornersEnabled = false;
              gothCornerRadiusOverride = false;
              gothCornerRadiusValue = 12;
              borderEnabled = false;
              borderColor = "surfaceText";
              borderOpacity = 1;
              borderThickness = 1;
              widgetOutlineEnabled = false;
              widgetOutlineColor = "primary";
              widgetOutlineOpacity = 1;
              widgetOutlineThickness = 1;
              fontScale = 1;
              iconScale = 1;
              autoHide = true;
              autoHideDelay = 250;
              showOnWindowsOpen = true;
              openOnOverview = false;
              visible = true;
              popupGapsAuto = true;
              popupGapsManual = 4;
              maximizeDetection = true;
              scrollEnabled = true;
              scrollXBehavior = "column";
              scrollYBehavior = "workspace";
              shadowIntensity = 0;
              shadowOpacity = 60;
              shadowColorMode = "default";
              shadowCustomColor = "#000000";
              clickThrough = false;
            }
          ];
          
          desktopClockEnabled = false;
          desktopClockStyle = "analog";
          desktopClockTransparency = 0.8;
          desktopClockColorMode = "primary";
          desktopClockCustomColor = {
            r = 1;
            g = 1;
            b = 1;
            a = 1;
            hsvHue = -1;
            hsvSaturation = 0;
            hsvValue = 1;
            hslHue = -1;
            hslSaturation = 0;
            hslLightness = 1;
            valid = true;
          };
          desktopClockShowDate = true;
          desktopClockShowAnalogNumbers = false;
          desktopClockShowAnalogSeconds = true;
          desktopClockX = -1;
          desktopClockY = -1;
          desktopClockWidth = 280;
          desktopClockHeight = 180;
          desktopClockDisplayPreferences = [ "all" ];
          
          systemMonitorEnabled = false;
          systemMonitorShowHeader = true;
          systemMonitorTransparency = 0.8;
          systemMonitorColorMode = "primary";
          systemMonitorCustomColor = {
            r = 1;
            g = 1;
            b = 1;
            a = 1;
            hsvHue = -1;
            hsvSaturation = 0;
            hsvValue = 1;
            hslHue = -1;
            hslSaturation = 0;
            hslLightness = 1;
            valid = true;
          };
          systemMonitorShowCpu = true;
          systemMonitorShowCpuGraph = true;
          systemMonitorShowCpuTemp = true;
          systemMonitorShowGpuTemp = false;
          systemMonitorGpuPciId = "";
          systemMonitorShowMemory = true;
          systemMonitorShowMemoryGraph = true;
          systemMonitorShowNetwork = true;
          systemMonitorShowNetworkGraph = true;
          systemMonitorShowDisk = true;
          systemMonitorShowTopProcesses = false;
          systemMonitorTopProcessCount = 3;
          systemMonitorTopProcessSortBy = "cpu";
          systemMonitorGraphInterval = 60;
          systemMonitorLayoutMode = "auto";
          systemMonitorX = -1;
          systemMonitorY = -1;
          systemMonitorWidth = 320;
          systemMonitorHeight = 480;
          systemMonitorDisplayPreferences = [ "all" ];
          
          configVersion = 6;
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
