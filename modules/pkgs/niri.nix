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
        focus-follows-mouse = _: {};

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
          variable-refresh-rate = _: {};
        };
      };

      spawn-at-startup = [
        [ "dbus-update-activation-environment" "--systemd" "WAYLAND_DISPLAY" "XDG_CURRENT_DESKTOP" "DISPLAY" ]
      ];

      binds = {
        "Mod+Backspace".spawn = [ "dms" "ipc" "lock" "lock" ];
        "Mod+Shift+Backspace".spawn = [ "dms" "ipc" "powermenu" "toggle" ];
        "Mod+Ctrl+Backspace" = _: {
          content = {
            power-off-monitors = {};
          };
        };

        "Mod+D".spawn = [ "${self.packages.${pkgs.stdenv.hostPlatform.system}.bemenu}/bin/bemenu-run" ];
        "Mod+Shift+D".spawn = [ "dms" "ipc" "spotlight" "toggle" ];
        "Mod+R".spawn = [ "kitty -e lf" ];
        "Mod+Return".spawn = [ "kitty" ];

        "Mod+B".spawn = [ "battery.sh" ];
        "Mod+N".spawn = [ "logseq" ];

        "Mod+C".spawn = [ "bookmarks.sh" "--save" ];
        "Mod+Shift+C".spawn = [ "bookmarks.sh" "--copy" ];
        "Mod+V".spawn = [ "bookmarks.sh" "--type" ];

        "Mod+Shift+B" = _: {
          content = {
            center-column = {};
          };
        };

        "Mod+Ctrl+C" = _: {
          content = {
            center-visible-columns = {};
          };
        };

        "Mod+F" = _: {
          content = {
            maximize-column = {};
          };
        };

        "Mod+Shift+F" = _: {
          content = {
            fullscreen-window = {};
          };
        };

        "Mod+Ctrl+F" = _: {
          content = {
            expand-column-to-available-width = {};
          };
        };

        "Mod+Shift+Slash" = _: {
          content = {
            show-hotkey-overlay = {};
          };
        };

        "Mod+W".spawn = [ "brave" ];
        "Mod+Q" = _: {
          content = {
            close-window = {};
          };

          props = {
            repeat = false;
          };
        };

        "Mod+Shift+Return" = _: {
          content = {
            toggle-overview = {};
          };

          props = {
            repeat = false;
          };
        };

        "Mod+Escape" = _: {
          content = {
            toggle-keyboard-shortcuts-inhibit = {};
          };

          props = {
            allow-inhibiting = false;
          };
        };

        "Print".screenshot = [];
        "Mod+XF86AudioRaiseVolume".screenshot = [];
        "Ctrl+Print".screenshot-screen = [];
        "Shift+Print".screenshot-window = [];

        "Mod+Left" = _: {
          content = {
            focus-monitor-left = {};
          };
        };

        "Mod+Down" = _: {
          content = {
            focus-monitor-down = {};
          };
        };

        "Mod+Up" = _: {
          content = {
            focus-monitor-up = {};
          };
        };

        "Mod+Right" = _: {
          content = {
            focus-monitor-right = {};
          };
        };

        "Mod+Shift+Left" = _: {
          content = {
            move-column-to-monitor-left = {};
          };
        };

        "Mod+Shift+Down" = _: {
          content = {
            move-column-to-monitor-down = {};
          };
        };

        "Mod+Shift+Up" = _: {
          content = {
            move-column-to-monitor-up = {};
          };
        };

        "Mod+Shift+Right" = _: {
          content = {
            move-column-to-monitor-right = {};
          };
        };


        "Mod+H".set-column-width = "-10%";
        "Mod+L".set-column-width = "+10%";
        "Mod+Shift+H".set-window-height = "+10%";
        "Mod+Shift+L".set-window-height = "-10%";
        "Mod+Y" = _: {
          content = {
            switch-preset-column-width = {};
          };
        };

        "Mod+Shift+Y" = _: {
          content = {
            toggle-column-tabbed-display = {};
          };
        };


        "Mod+Shift+Space" = _: {
          content = {
            toggle-window-floating = {};
          };
        };

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
        "Mod+J" = _: {
          content = {
            focus-column-left-or-last = {};
          };
        };

        "Mod+K" = _: {
          content = {
            focus-column-right-or-first = {};
          };
        };

        "Mod+Shift+J" = _: {
          content = {
            move-column-left-or-to-monitor-left = {};
          };
        };

        "Mod+Shift+K" = _: {
          content = {
            move-column-right-or-to-monitor-right = {};
          };
        };

        "Mod+Alt+J" = _: {
          content = {
            consume-or-expel-window-left = {};
          };
        };

        "Mod+Alt+K" = _: {
          content = {
            consume-or-expel-window-right = {};
          };
        };

        "Mod+Ctrl+J" = _: {
          content = {
            focus-window-or-workspace-down = {};
          };
        };

        "Mod+Ctrl+K" = _: {
          content = {
            focus-window-or-workspace-up = {};
          };
        };

        "Mod+Ctrl+Shift+J" = _: {
          content = {
            move-window-down-or-to-workspace-down = {};
          };
        };

        "Mod+Ctrl+Shift+K" = _: {
          content = {
            move-window-up-or-to-workspace-up = {};
          };
        };


        "XF86MonBrightnessUp" = _: {
          content = {
            spawn = [ "brightnessctl" "--class=backlight" "set" "+10%" ];
          };

          props = {
            allow-when-locked = true;
          };
        };
        "XF86MonBrightnessDown" = _: {
          content = {
            spawn = [ "brightnessctl" "--class=backlight" "set" "10%-" ];
          };

          props = {
            allow-when-locked = true;
          };
        };
        "XF86KbdBrightnessUp" = _: {
          content = {
            spawn = [ "brightnessctl" "--device=smc::kbd_backlight" "set" "+10%" ];
          };

          props = {
            allow-when-locked = true;
          };
        };
        "XF86KbdBrightnessDown" = _: {
          content = {
            spawn = [ "brightnessctl" "--device=smc::kbd_backlight" "set" "10%-" ];
          };

          props = {
            allow-when-locked = true;
          };
        };
        "XF86AudioRaiseVolume" = _: {
          content = {
            spawn = [ "pulsemixer" "--change-volume" "+5" ];
          };

          props = {
            allow-when-locked = true;
          };
        };
        "XF86AudioLowerVolume" = _: {
          content = {
            spawn = [ "pulsemixer" "--change-volume" "-5" ];
          };

          props = {
            allow-when-locked = true;
          };
        };
        "XF86AudioMute" = _: {
          content = {
            spawn = [ "pulsemixer" "--toggle-mute" ];
          };

          props = {
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
