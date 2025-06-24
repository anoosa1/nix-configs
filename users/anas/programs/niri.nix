{
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

        spawn-at-startup = [
          { command = [ "xwayland-satellite" ]; }
        ];

        environment = {
          DISPLAY = ":0";
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

        binds = with config.lib.niri.actions; {
          "Mod+Backspace".action.spawn = "waylock";
          "Mod+Shift+Backspace".action = quit;
          "Mod+Ctrl+Backspace".action = power-off-monitors;

          "Mod+D".action.spawn = "bemenu-run";
          "Mod+Return".action.spawn = "alacritty";
          "Mod+Shift+Slash".action = show-hotkey-overlay;

          "Mod+C".action = center-column;
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
          "Mod+Shift+H".action = set-window-height "-10%";
          "Mod+Shift+L".action = set-window-height "+10%";
          "Mod+Y".action = switch-preset-column-width;

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

          #"Mod+J".action = focus-column-left;
          #"Mod+H".action = focus-window-down;
          #"Mod+L".action = focus-window-up;
          #"Mod+K".action = focus-column-right;
          #"Mod+Shift+J".action = move-column-left;
          #"Mod+Shift+H".action = move-window-down;
          #"Mod+Shift+L".action = move-window-up;
          #"Mod+Shift+K".action = move-column-right;

          "Mod+J".action = focus-window-up-or-column-left;
          "Mod+K".action = focus-window-down-or-column-right;
          "Mod+Shift+J".action = move-column-left;
          "Mod+Shift+K".action = move-column-right;
          "Mod+Alt+J".action = focus-workspace-down;
          "Mod+Alt+K".action = focus-workspace-up;
          "Mod+Alt+Shift+J".action = move-column-to-workspace-down;
          "Mod+Alt+Shift+K".action = move-column-to-workspace-up;
        };

        layout = {
          gaps = 0;

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
