{
  programs = {
    waybar = {
      enable = true;
      style = ./style.css;

      systemd = {
        enable = true;
      };

      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          start_hidden = true;
          height = 36;
          modules-left = [ "river/tags" "river/window" "mpris" ];
          modules-right = [ "tray" "network" "pulseaudio" "pulseaudio#mic" "battery" "custom/weather" "clock" ];

          "river/tags" = {
            hide-vacant = true;
            tag-labels = [ "" "" "" "4" "5" "6" "7" "8" "9"];
          };

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

          "river/window" = {
            format = "{}";
            max-length = 25;
            on-scroll-up = "riverctl focus-view previous";
            on-scroll-down = "riverctl focus-view next";
          };

          "hyprland/window" = {
            max-length = 25;
          };

          "custom/weather" = {
            format = "{}";
            exec = "curl -s 'wttr.in/yyz?format=%c%t'";
            interval = 18000;
            on-click = "mullvad-browser wttr.in";
            class = "weather";
          };

          pulseaudio = {
            format = "{icon} {volume}%";
            format-muted = " {volume}%";
            format-bluetooth = " {volume}%";
            format-bluetooth-muted = "  {volume}%";
            format-icons = {
              default = [ "" "" "" "" ];
              headphones = "";
              speaker = "";
              hands-free = "";
              headset = "";
              phone = "";
              car = "";
              hifi = "";
            };

            scroll-step = 5;
            on-click = "alacritty -e pulsemixer";
            on-scroll-up = "pamixer -i 5";
            on-scroll-down = "pamixer -d 5";
          };

          "pulseaudio#mic" = {
            format = "{format_source}";
            format-source = " {volume}%";
            format-source-muted = " {volume}%";
            scroll-step = 5;
            on-click = "alacritty -e pulsemixer";
            on-scroll-up = "pamixer --default-source -i 5";
            on-scroll-down = "pamixer --get-source -d 5";
          };

          network = {
            format = "{icon}";
            format-alt = "{ipaddr} {icon}";
            format-alt-click = "click-right";

            format-icons = {
              wifi = [ "" "" "" ];
              disconnected = "";
              disable = "";
              ethernet = "";
            };

            tooltip-format = "Signal: {signalStrength}%";
            interval = 10;
            on-click = "alacritty -e nmtui";
          };
          
          battery = {
            states = {
              good = 90;
              warning = 50;
              critical = 25;
            };

            format = "{icon}{capacity}%";
            format-charging = "{capacity}%";
            format-icons = [ "" "" "" "" "" ""];
            tooltip-format = "Time: {time}\nHealth: {health}";
          };

          clock = {
            tooltip = true;
            interval = 1;
            format = "{:%B %d  %H:%M:%S}";
            tooltip-format = "{:%A, %B %d %Y %H:%M:%S}";
          };

          tray = {
            icon-size = 18;
            spacing = 10;
          };

          mpris = {
            format = "{player_icon} - {status_icon} {title}";
            format-paused = "{player_icon} - {status_icon} <i>{title}</i>";
            format-stopped = "{status_icon}";
            title-len = 20;
            on-click = "alacritty -e rmpc";
            on-click-right = "playerctl play-pause";
            on-scroll-up = "playerctl next";
            on-scroll-down = "playerctl previous";
            on-click-middle = "playerctl stop";

            player-icons = {
              default = "";
            };

            status-icons = {
              playing = "";
              stopped = "";
              paused = "";
            };
          };
        };
      };
    };
  };
}
