{
  programs = {
    waybar = {
      enable = true;
      #style = ./style.css;

      systemd = {
        enable = true;
      };

      settings = {
        mainBar = {
          layer = "top";
          position = "bottom";
          height = 30;
          modules-left = ["hyprland/workspaces"];
          modules-center = ["hyprland/window"];
          modules-right = ["custom/weather" "pulseaudio" "clock" "tray"];
          "hyprland/workspaces" = {
            disable-scroll = true;
            show-special = true;
            special-visible-only = true;
            all-outputs = false;
            format = "{icon}";
            format-icons = {
              "1" = "";
              "2" = "";
              "3" = "";
              "4" = "";
              "5" = "";
              "magic" = "";
            };

            persistent-workspaces = {
              "*" = 5;
            };
          };

          "custom/weather" = {
            format = " {} ";
            exec = "curl -s 'wttr.in/yyz?format=%c%t'";
            interval = 1000;
            class = "weather";
          };

          "pulseaudio" = {
            format = "{icon} {volume}%";
            format-bluetooth = "{icon} {volume}% ";
            format-muted = "";
            format-icons = {
              "headphones" = "";
              "handsfree" = "";
              "headset" = "";
              "phone" = "";
              "portable" = "";
              "car" = "";
              "default" = ["" ""];
            };
            on-click = "alacritty -e pulsemixer";
          };

          "clock" = {
            tooltip = true;
            interval = 1;
            format = "{:%H:%M:%S}";
            tooltip-format = "{:%A, %B %d %Y %H:%M:%S}";
          };

          "tray" = {
            icon-size = 14;
            spacing = 5;
          };
        };
      };
    };
  };
}
