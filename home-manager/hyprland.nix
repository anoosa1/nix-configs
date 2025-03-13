{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = false;
    systemd.enable = true;
    settings = {
      "$mod" = "SUPER";
      bind =
        [
          "$mod, RETURN, exec, alacritty"
          "$mod, D, exec, bemenu-run"
          "$mod, W, exec, com.brave.Browser"
        ]
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
          builtins.concatLists (builtins.genList (i:
            let ws = i + 1;
            in [
              "$mod, code:1${toString i}, workspace, ${toString ws}"
              "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
            ]
          )
          9)
      );
    };
  };
}
