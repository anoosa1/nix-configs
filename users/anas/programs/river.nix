{
  pkgs,
  ...
}:
{
  wayland.windowManager.river = {
    enable = true;

    xwayland = {
      enable = true;
    };

    systemd = {
      enable = true;
    };

    extraConfig = ''
      riverctl keyboard-layout -options "caps:swapescape" us
    '';

    settings = {
      border-width = 2;
      set-repeat = "50 300";
      xcursor-theme = "Bibata-Modern-Ice 24";
      output-layout = "rivertile";
      focus-follows-cursor = "normal";

      hide-cursor = {
        timeout = 5000;
        when-typing = true;
      };

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
          "Super W" = "spawn brave";
          "Super D" = "spawn 'dmenu_run'";
          "Super+Shift D" = "spawn 'systemctl --user kill --signal=SIGUSR1 waybar.service'";
          "Super Backspace" = "spawn '${pkgs.scripts.dmenupower}/bin/dmenupower.sh'";

          "Super Q" = "close";
          "Super+Shift Backspace" = "exit";
          
          "Super J" = "focus-view next";
          "Super K" = "focus-view previous";
          "Super+Shift J" = "swap next";
          "Super+Shift K" = "swap previous";

          "Super Period" = "focus-output next";
          "Super Comma" = "focus-output previous";
          "Super+Shift Period" = "send-to-output next";
          "Super+Shift Comma" = "send-to-output previous";

          "Super Space" = "zoom";
          "Super+Shift Space" = "toggle-float";

          "Super B" = "spawn 'bookmarks.sh --save'";
          "Super+Shift B" = "spawn 'bookmarks.sh --type'";
          "Super+Control B" = "spawn 'bookmarks.sh --copy'";
          "Super+Shift+Control B" = "spawn 'bookmarks.sh --delete'";

          "Super H" = "send-layout-cmd rivertile 'main-ratio -0.05'";
          "Super L" = "send-layout-cmd rivertile 'main-ratio +0.05'";

          "Super+Alt H" = "send-layout-cmd rivertile 'main-count +1'";
          "Super+Alt L" = "send-layout-cmd rivertile 'main-count -1'";

          "Super+Control H" = "move left 100";
          "Super+Control J" = "move down 100";
          "Super+Control K" = "move up 100";
          "Super+Control L" = "move right 100";

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
          "None Print" = "spawn '${pkgs.scripts.dmenuscreenshot}/bin/dmenuscreenshot.sh'";

          "None XF86MonBrightnessUp" = "spawn '${pkgs.brightnessctl}/bin/brightnessctl set +5%'";
          "None XF86MonBrightnessDown" = "spawn '${pkgs.brightnessctl}/bin/brightnessctl set 5%-'";
          "None XF86KbdBrightnessUp" = "spawn '${pkgs.brightnessctl}/bin/brightnessctl --device=smc::kbd_backlight set +10%'";
          "None XF86KbdBrightnessDown" = "spawn '${pkgs.brightnessctl}/bin/brightnessctl --device=smc::kbd_backlight set 10%-'";
          "None XF86AudioRaiseVolume" = "spawn '${pkgs.pamixer}/bin/pamixer -i 5'";
          "None XF86AudioLowerVolume" = "spawn '${pkgs.pamixer}/bin/pamixer -d 5'";
          "None XF86AudioMute" = "spawn '${pkgs.pamixer}/bin/pamixer --toggle-mute'";
          "None XF86AudioPlay" = "spawn 'playerctl play-pause'";
          "None XF86AudioPrev" = "spawn 'playerctl previous'";
          "None XF86AudioNext" = "spawn 'playerctl next'";
          "None XF86AudioStop" = "spawn 'playerctl stop'";
          "None XF86AudioMedia" = "spawn 'alacritty -e rmpc'";
          "Super XF86AudioRaiseVolume" = "spawn '${pkgs.pamixer}/bin/pamixer --default-source -i 5'";
          "Super XF86AudioLowerVolume" = "spawn '${pkgs.pamixer}/bin/pamixer --default-source -d 5'";
          "Super XF86AudioMute" = "spawn '${pkgs.pamixer}/bin/pamixer --default-source --toggle-mute'";
          "Super XF86AudioPlay" = "spawn 'rmpc togglepause'";
          "Super XF86AudioPrev" = "spawn 'rmpc prev'";
          "Super XF86AudioNext" = "spawn 'rmpc next'";
          "Super XF86AudioStop" = "spawn 'rmpc stop'";
          "Super XF86AudioMedia" = "spawn 'alacritty -e termusic'";
        };

        passthrough = {
          "Super F11" = "enter-mode normal";
        };

        locked = {
          "None XF86MonBrightnessUp" = "spawn '${pkgs.brightnessctl}/bin/brightnessctl set +5%'";
          "None XF86MonBrightnessDown" = "spawn '${pkgs.brightnessctl}/bin/brightnessctl set 5%-'";
          "None XF86KbdBrightnessUp" = "spawn '${pkgs.brightnessctl}/bin/brightnessctl --device=smc::kbd_backlight set +10%'";
          "None XF86KbdBrightnessDown" = "spawn '${pkgs.brightnessctl}/bin/brightnessctl --device=smc::kbd_backlight set 10%-'";
          "None XF86AudioRaiseVolume" = "spawn '${pkgs.pamixer}/bin/pamixer -i 5'";
          "None XF86AudioLowerVolume" = "spawn '${pkgs.pamixer}/bin/pamixer -d 5'";
          "None XF86AudioMute" = "spawn '${pkgs.pamixer}/bin/pamixer --toggle-mute'";
          "None XF86AudioPlay" = "spawn 'playerctl play-pause'";
          "None XF86AudioPrev" = "spawn 'playerctl previous'";
          "None XF86AudioNext" = "spawn 'playerctl next'";
          "None XF86AudioStop" = "spawn 'playerctl stop'";
          "Super XF86AudioRaiseVolume" = "spawn '${pkgs.pamixer}/bin/pamixer --default-source -i 5'";
          "Super XF86AudioLowerVolume" = "spawn '${pkgs.pamixer}/bin/pamixer --default-source -d 5'";
          "Super XF86AudioMute" = "spawn '${pkgs.pamixer}/bin/pamixer --default-source --toggle-mute'";
          "Super XF86AudioPlay" = "spawn 'rmpc togglepause'";
          "Super XF86AudioPrev" = "spawn 'rmpc prev'";
          "Super XF86AudioNext" = "spawn 'rmpc next'";
          "Super XF86AudioStop" = "spawn 'rmpc stop'";
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
        "'rivertile -view-padding 0 -outer-padding 0'"
        "'wlr-randr --output eDP-1 --scale 1.5'"
      ];
    };
  };
}
