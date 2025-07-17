{
  pkgs,
  config,
  ...
}:
{
  programs = {
    niri = {
      settings = {
        screenshot-path = "~/pics/Screenshots/Screenshot_%Y%m%d-%H%M%S";
        prefer-no-csd = true;

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
          #hide-not-bound = true;
          skip-at-startup = true;
        };

        input = {
          keyboard = {
            numlock = true;
            repeat-delay = 300;
            repeat-rate = 50;


            xkb = {
              layout = "us";
              options = "caps:swapescape";
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

        spawn-at-startup = [
          { command = [ "xwayland-satellite" ]; }
        ];

        binds = with config.lib.niri.actions; {
          "Mod+Backspace".action.spawn = "swaylock";
          "Mod+Shift+Backspace".action = quit;
          "Mod+Ctrl+Backspace".action = power-off-monitors;

          "Mod+D".action.spawn = "bemenu-run";
          "Mod+Return".action.spawn = "kitty";
          "Mod+Shift+Slash".action = show-hotkey-overlay;

          "Mod+C".action = center-column;
          "Mod+B".action = spawn "battery.sh";
          "Mod+Ctrl+C".action = center-visible-columns;

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

          "Print".action = screenshot;
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
            action = spawn "${pkgs.brightnessctl}/bin/brightnessctl" "--class=backlight" "set" "+10%";
            allow-when-locked = true;
          };
          "XF86MonBrightnessDown" = {
            action = spawn "${pkgs.brightnessctl}/bin/brightnessctl" "--class=backlight" "set" "10%-";
            allow-when-locked = true;
          };
          "XF86KbdBrightnessUp" = {
            action = spawn "${pkgs.brightnessctl}/bin/brightnessctl" "--device=smc::kbd_backlight" "set" "+10%";
            allow-when-locked = true;
          };
          "XF86KbdBrightnessDown" = {
            action = spawn "${pkgs.brightnessctl}/bin/brightnessctl" "--device=smc::kbd_backlight" "set" "10%-";
            allow-when-locked = true;
          };
          "XF86AudioRaiseVolume" = {
            action = spawn "${pkgs.pamixer}/bin/pamixer" "-i" "5";
            allow-when-locked = true;
          };
          "XF86AudioLowerVolume" = {
            action = spawn "${pkgs.pamixer}/bin/pamixer" "-d" "5";
            allow-when-locked = true;
          };
          "XF86AudioMute" = {
            action = spawn "${pkgs.pamixer}/bin/pamixer" "--toggle-mute";
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

        layout = {
          gaps = 0;
          default-column-display = "tabbed";

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
  };
}
