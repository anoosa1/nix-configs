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
          position = "top";
          height = 30;
          modules-left = ["hyprland/workspaces" "hyprland/window"];
          modules-center = ["clock" "custom/weather"];
          modules-right = ["tray" "network" "pulseaudio" "battery"];
          "hyprland/workspaces" = {
            disable-scroll = true;
            show-special = true;
            special-visible-only = true;
            all-outputs = false;
            format = "{icon}";
            format-icons = {
              "1" = "";
              "2" = "";
              "3" = "";
              "magic" = "";
            };

            persistent-workspaces = {
              "*" = 3;
            };
          };

          "hyprland/window" = {
            max-length = 25;
          };

          "custom/weather" = {
            format = " {} ";
            exec = "curl -s 'wttr.in/yyz?format=%c%t'";
            interval = 1000;
            on-click = "mullvad-browser wttr.in";
            class = "weather";
          };

          "pulseaudio" = {
            format = "{icon} {volume}%";
            format-bluetooth = "{icon} {volume}% ";
            format-muted = "🔇";
            format-icons = {
              "headphones" = "🎧";
              "default" = ["🔉" "🔊"];
            };
            on-click = "alacritty -e pulsemixer";
          };

          "network" = {
            format-wifi = "🛜";
            format-disconnected = "❎";
            tooltip-format = "Signal: {signalStrength}%";
            interval = 10;
            on-click = "alacritty -e nmtui";
          };
          
          "battery" = {
            states = {
              warning = 30;
              critical = 10;
            };
            format = "{icon}{capacity}%";
            format-charging = "🔌{capacity}%";
            format-icons = ["❗" "🪫" "🟢" "🔋" "🔋"];
          };

          "clock" = {
            tooltip = true;
            interval = 1;
            format = "{:%B %d  %H:%M:%S}";
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
