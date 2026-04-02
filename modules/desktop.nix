{
  self,
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
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.niri;
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
          
          runUserMatugenTemplates = false;
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
