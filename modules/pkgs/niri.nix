# modules/pkgs/niri.nix
{
  self,
  inputs,
  ...
}:
{
  flake.wrappers.niri = { pkgs, lib, ... }: {
    imports = [ inputs.wrappers.lib.wrapperModules.niri ];

    settings = {
      screenshot-path = "~/pics/screenshots/Screenshot_%Y%m%d-%H%M%S.png";
      prefer-no-csd = true;

      animations = {
        slowdown = 0.7;
      };

      cursor = {
        hide-after-inactive-ms = 3000;
        hide-when-typing = true;
      };

      debug = {
        honor-xdg-activation-with-invalid-serial = [];
      };

      environment = {
        DISPLAY = ":0";
      };

      hotkey-overlay = {
        skip-at-startup = true;
      };

      input = {
        focus-follows-mouse = null;

        keyboard = {
          numlock = true;
          repeat-delay = 300;
          repeat-rate = 50;


          xkb = {
            layout = "us";
          };
        };

        mouse = {
          accel-profile = "flat";
          accel-speed = -0.3;
        };
      };

      outputs = {
        HDMI-A-1 = {
          mode = "1920x1080@100.00";
          variable-refresh-rate = null;
        };
      };

      spawn-at-startup = [
        [ "dbus-update-activation-environment" "--systemd" "WAYLAND_DISPLAY" "XDG_CURRENT_DESKTOP" "DISPLAY" ]
      ];

      binds = {
        "Mod+Backspace".spawn = [ "dms" "ipc" "lock" "lock" ];
        "Mod+Shift+Backspace".spawn = [ "dms" "ipc" "powermenu" "toggle" ];
        "Mod+Ctrl+Backspace".power-off-monitors = null;

        "Mod+D".spawn = [ "${self.packages.${pkgs.system}.bemenu}/bin/bemenu-run" ];
        "Mod+Shift+D".spawn = [ "dms" "ipc" "spotlight" "toggle" ];
        "Mod+R".spawn = [ "kitty -e lf" ];
        "Mod+Return".spawn = [ "kitty" ];

        "Mod+B".spawn = [ "battery.sh" ];
        "Mod+N".spawn = [ "logseq" ];

        "Mod+C".spawn = [ "bookmarks.sh" "--save" ];
        "Mod+Shift+C".spawn = [ "bookmarks.sh" "--copy" ];
        "Mod+V".spawn = [ "bookmarks.sh" "--type" ];

        "Mod+Shift+B".center-column = null;
        "Mod+Ctrl+C".center-visible-columns = null;
        "Mod+F".maximize-column = null;
        "Mod+Shift+F".fullscreen-window = null;
        "Mod+Ctrl+F".expand-column-to-available-width = null;
        "Mod+Shift+Slash".show-hotkey-overlay = null;

        "Mod+W".spawn = [ "brave" ];
        "Mod+Q" = {
          close-window = null;

          _attrs = {
            repeat = false;
          };
        };

        "Mod+Shift+Return" = {
          toggle-overview = null;

          _attrs = {
            repeat = false;
          };
        };

        "Mod+Escape" = {
          toggle-keyboard-shortcuts-inhibit = null;

          _attrs = {
            allow-inhibiting = false;
          };
        };

        "Print".screenshot = [];
        "Mod+XF86AudioRaiseVolume".screenshot = [];
        "Ctrl+Print".screenshot-screen = [];
        "Shift+Print".screenshot-window = [];

        "Mod+Left".focus-monitor-left = null;
        "Mod+Down".focus-monitor-down = null;
        "Mod+Up".focus-monitor-up = null;
        "Mod+Right".focus-monitor-right = null;
        "Mod+Shift+Left".move-column-to-monitor-left = null;
        "Mod+Shift+Down".move-column-to-monitor-down = null;
        "Mod+Shift+Up".move-column-to-monitor-up = null;
        "Mod+Shift+Right".move-column-to-monitor-right = null;

        "Mod+H".set-column-width = "-10%";
        "Mod+L".set-column-width = "+10%";
        "Mod+Shift+H".set-window-height = "+10%";
        "Mod+Shift+L".set-window-height = "-10%";
        "Mod+Y".switch-preset-column-width = null;
        "Mod+Shift+Y".toggle-column-tabbed-display = null;

        "Mod+Shift+Space".toggle-window-floating = null;
        "Mod+1".focus-workspace = 1;
        "Mod+2".focus-workspace = 2;
        "Mod+3".focus-workspace = 3;
        "Mod+4".focus-workspace = 4;
        "Mod+5".focus-workspace = 5;
        "Mod+6".focus-workspace = 6;
        "Mod+7".focus-workspace = 7;
        "Mod+8".focus-workspace = 8;
        "Mod+9".focus-workspace = 9;
        "Mod+Shift+1".move-column-to-workspace = 1;
        "Mod+Shift+2".move-column-to-workspace = 2;
        "Mod+Shift+3".move-column-to-workspace = 3;
        "Mod+Shift+4".move-column-to-workspace = 4;
        "Mod+Shift+5".move-column-to-workspace = 5;
        "Mod+Shift+6".move-column-to-workspace = 6;
        "Mod+Shift+7".move-column-to-workspace = 7;
        "Mod+Shift+8".move-column-to-workspace = 8;
        "Mod+Shift+9".move-column-to-workspace = 9;
        "Mod+J".focus-column-left-or-last = null;
        "Mod+K".focus-column-right-or-first = null;
        "Mod+Shift+J".move-column-left-or-to-monitor-left = null;
        "Mod+Shift+K".move-column-right-or-to-monitor-right = null;
        "Mod+Alt+J".consume-or-expel-window-left = null;
        "Mod+Alt+K".consume-or-expel-window-right = null;
        "Mod+Ctrl+J".focus-window-or-workspace-down = null;
        "Mod+Ctrl+K".focus-window-or-workspace-up = null;
        "Mod+Ctrl+Shift+J".move-window-down-or-to-workspace-down = null;
        "Mod+Ctrl+Shift+K".move-window-up-or-to-workspace-up = null;

        "XF86MonBrightnessUp" = {
          spawn = [ "brightnessctl" "--class=backlight" "set" "+10%" ];

          _attrs = {
            allow-when-locked = true;
          };
        };
        "XF86MonBrightnessDown" = {
          spawn = [ "brightnessctl" "--class=backlight" "set" "10%-" ];

          _attrs = {
            allow-when-locked = true;
          };
        };
        "XF86KbdBrightnessUp" = {
          spawn = [ "brightnessctl" "--device=smc::kbd_backlight" "set" "+10%" ];

          _attrs = {
            allow-when-locked = true;
          };
        };
        "XF86KbdBrightnessDown" = {
          spawn = [ "brightnessctl" "--device=smc::kbd_backlight" "set" "10%-" ];

          _attrs = {
            allow-when-locked = true;
          };
        };
        "XF86AudioRaiseVolume" = {
          spawn = [ "pulsemixer" "--change-volume" "+5" ];

          _attrs = {
            allow-when-locked = true;
          };
        };
        "XF86AudioLowerVolume" = {
          spawn = [ "pulsemixer" "--change-volume" "-5" ];

          _attrs = {
            allow-when-locked = true;
          };
        };
        "XF86AudioMute" = {
          spawn = [ "pulsemixer" "--toggle-mute" ];

          _attrs = {
            allow-when-locked = true;
          };
        };
      };

      window-rules = [
        {
          geometry-corner-radius = 20.0;
          clip-to-geometry = true;
        }
      ];

      layout = {
        gaps = 0;

        border = {
          width = 3;

          active-color = self.theme.base08;
          inactive-color = self.theme.base00;
        };

        default-column-width = {
          proportion = 0.5;
        };

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
}
