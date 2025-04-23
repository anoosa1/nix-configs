{ config, pkgs, ... }:

{
  services = {
    hyprpaper = {
      enable = true;
    };
  };
  
  wayland.windowManager.hyprland = {
    enable = true;

    xwayland = {
      enable = true;
    };

    systemd = {
      enable = false;
      enableXdgAutostart = false;
    };

    settings = {
      "$mod" = "SUPER";
      "$browser" = "mullvad-browser";
      "$terminal" = "alacritty";

      exec-once = [
        "dbus-update-activation-environment --systemd --all"
      ];

      general = {
        gaps_in = 5;
        gaps_out = 5;

        border_size = 2;

        resize_on_border = true;

        allow_tearing = false;
        layout = "master";
      };

      decoration = {
        rounding = 0;

        active_opacity = 1.0;
        inactive_opacity = 1.0;

        shadow = {
          enabled = false;
        };

        blur = {
          enabled = false;
        };
      };

      animations = {
        enabled = false;
      };

      input = {
        numlock_by_default = true;
        repeat_delay = 250;
        repeat_rate = 35;
        kb_options = "caps:swapescape";
      };

      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
      };

      bind = [
        # apps
        "$mod, RETURN, exec, $terminal"
        "$mod, d, exec, bemenu-run"
        "$mod, w, exec, $browser"
        "$mod, b, exec, systemctl --user kill --signal=SIGUSR1 waybar.service"

        # focus
        "$mod, l, movefocus, l"
        "$mod, h, movefocus, r"
        "$mod, k, movefocus, u"
        "$mod, j, movefocus, d"
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"

        # moving windows
        "$mod SHIFT, l,  swapwindow, l"
        "$mod SHIFT, h, swapwindow, r"
        "$mod SHIFT, k,    swapwindow, u"
        "$mod SHIFT, j,  swapwindow, d"
        "$mod SHIFT, left,  swapwindow, l"
        "$mod SHIFT, right, swapwindow, r"
        "$mod SHIFT, up,    swapwindow, u"
        "$mod SHIFT, down,  swapwindow, d"

        # workspaces
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"

        # moving windows to workspaces
        "$mod SHIFT, 1, movetoworkspacesilent, 1"
        "$mod SHIFT, 2, movetoworkspacesilent, 2"
        "$mod SHIFT, 3, movetoworkspacesilent, 3"
        "$mod SHIFT, 4, movetoworkspacesilent, 4"
        "$mod SHIFT, 5, movetoworkspacesilent, 5"
        "$mod SHIFT, 6, movetoworkspacesilent, 6"
        "$mod SHIFT, 7, movetoworkspacesilent, 7"
        "$mod SHIFT, 8, movetoworkspacesilent, 8"
        "$mod SHIFT, 9, movetoworkspacesilent, 9"
        "$mod SHIFT, 0, movetoworkspacesilent, 10"

        "$mod, BACKSPACE, exit,"
        "$mod, Q, killactive,"
      ];

      # resize with mouse
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
    };
  };
}
