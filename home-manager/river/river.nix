{ config, pkgs, ... }:

{
  wayland.windowManager.river = {
    enable = true;

    xwayland = {
      enable = true;
    };

    systemd = {
      enable = true;
    };

    settings = {
      border-width = 2;
      set-repeat = "50 300";
      xcursor-theme = "Bibata-Modern-Ice 24";
      output-layout = "rivertile";

      declare-mode = [
        "locked"
        "normal"
        "passthrough"
      ];

      input = {
        pointer-1133-49291-Logitech_G502_HERO_Gaming_Mouse = {
          accel-profile = "flat";
          events = true;
          pointer-accel = -0.3;
        };
      };

      map = {
        normal = {
          "Super Return" = "spawn alacritty";
          "Super W" = "spawn mullvad-browser";
          "Super D" = "spawn 'rofi -show run'";
          "Super B" = "spawn 'systemctl --user kill --signal=SIGUSR1 waybar.service'";
          "Super Backspace" = "spawn 'hyprlock --immediate'";

          "Super Q" = "close";
          "Super+Shift Backspace" = "exit";
          
          "Super J" = "focus-view next";
          "Super K" = "focus-view previous";
          "Super+Control J" = "swap next";
          "Super+Control K" = "swap previous";

          "Super Period" = "focus-output next";
          "Super Comma" = "focus-output previous";
          "Super+Shift Period" = "send-to-output next";
          "Super+Shift Comma" = "send-to-output previous";

          "Super Space" = "turn zoom";
          "Super+Shift Space" = "toggle-float";

          "Super H" = "send-layout-cmd rivertile 'main-ratio -0.05'";
          "Super L" = "send-layout-cmd rivertile 'main-ratio +0.05'";

          "Super+Alt H" = "send-layout-cmd rivertile 'main-count +1'";
          "Super+Alt L" = "send-layout-cmd rivertile 'main-count -1'";

          "Super+Shift H" = "move left 100";
          "Super+Shift J" = "move down 100";
          "Super+Shift K" = "move up 100";
          "Super+Shift L" = "move right 100";

          "Super+Alt+Control H" = "snap left";
          "Super+Alt+Control J" = "snap down";
          "Super+Alt+Control K" = "snap up";
          "Super+Alt+Control L" = "snap right";

          "Super+Alt+Shift H" = "resize horizontal -100";
          "Super+Alt+Shift J" = "resize vertical 100";
          "Super+Alt+Shift K" = "resize vertical -100";
          "Super+Alt+Shift L" = "resize horizontal 100";

          "Super 1" = "set-focused-tags 1";
          "Super 2" = "set-focused-tags 2";
          "Super 3" = "set-focused-tags 4";
          "Super 4" = "set-focused-tags 8";
          "Super 5" = "set-focused-tags 16";
          "Super 6" = "set-focused-tags 32";
          "Super 7" = "set-focused-tags 64";
          "Super 8" = "set-focused-tags 128";
          "Super 9" = "set-focused-tags 256";

          "Super+Shift 1" = "set-view-tags 1";
          "Super+Shift 2" = "set-view-tags 2";
          "Super+Shift 3" = "set-view-tags 4";
          "Super+Shift 4" = "set-view-tags 8";
          "Super+Shift 5" = "set-view-tags 16";
          "Super+Shift 6" = "set-view-tags 32";
          "Super+Shift 7" = "set-view-tags 64";
          "Super+Shift 8" = "set-view-tags 128";
          "Super+Shift 9" = "set-view-tags 256";

          "Super+Control 1" = "toggle-focused-tags 1";
          "Super+Control 2" = "toggle-focused-tags 2";
          "Super+Control 3" = "toggle-focused-tags 4";
          "Super+Control 4" = "toggle-focused-tags 8";
          "Super+Control 5" = "toggle-focused-tags 16";
          "Super+Control 6" = "toggle-focused-tags 32";
          "Super+Control 7" = "toggle-focused-tags 64";
          "Super+Control 8" = "toggle-focused-tags 128";
          "Super+Control 9" = "toggle-focused-tags 256";

          "Super+Shift+Control 1" = "toggle-view-tags 1";
          "Super+Shift+Control 2" = "toggle-view-tags 2";
          "Super+Shift+Control 3" = "toggle-view-tags 4";
          "Super+Shift+Control 4" = "toggle-view-tags 8";
          "Super+Shift+Control 5" = "toggle-view-tags 16";
          "Super+Shift+Control 6" = "toggle-view-tags 32";
          "Super+Shift+Control 7" = "toggle-view-tags 64";
          "Super+Shift+Control 8" = "toggle-view-tags 128";
          "Super+Shift+Control 9" = "toggle-view-tags 256";

          "Super 0" = "set-focused-tags 4294967295";
          "Super+Shift 0" = "set-view-tags 4294967295";

          "Super F" = "toggle-fullscreen";

          "Super F11" = "enter-mode passthrough";

          "None XF86AudioRaiseVolume" = "spawn 'pamixer -i 5'";
          "None XF86AudioLowerVolume" = "spawn 'pamixer -d 5'";
          "None XF86AudioMute" = "spawn 'pamixer --toggle-mute'";
          "Super XF86AudioRaiseVolume" = "spawn 'pamixer --default-source -i 5'";
          "Super XF86AudioLowerVolume" = "spawn 'pamixer --default-source -d 5'";
          "Super XF86AudioMute" = "spawn 'pamixer --default-source --toggle-mute'";
          "None XF86MonBrightnessUp" = "spawn 'brightnessctl set +5%'";
          "None XF86MonBrightnessDown" = "spawn 'brightnessctl set -5%'";
        };

        passthrough = {
          "Super F11" = "enter-mode normal";
        };

        locked = {
          "Super XF86AudioRaiseVolume" = "spawn 'pamixer --default-source -i 5'";
          "Super XF86AudioLowerVolume" = "spawn 'pamixer --default-source -d 5'";
          "Super XF86AudioMute" = "spawn 'pamixer --default-source --toggle-mute'";
          "None XF86AudioRaiseVolume" = "spawn 'pamixer -i 5'";
          "None XF86AudioLowerVolume" = "spawn 'pamixer -d 5'";
          "None XF86AudioMute" = "spawn 'pamixer --toggle-mute'";
          "None XF86MonBrightnessUp" = "spawn 'brightnessctl set +5%'";
          "None XF86MonBrightnessDown" = "spawn 'brightnessctl set -5%'";
        };
      };

      map-pointer = {
        normal = {
          "Super BTN_LEFT" = "move-view";
          "Super BTN_RIGHT" = "resize-view";
          "Super BTN_MIDDLE" = "toggle-float";
        };
      };

      spawn = [
        "rivertile"
      ];
    };
  };
}
