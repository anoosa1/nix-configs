{
  lib,
  config,
  ...
}:
{
  config = lib.mkIf config.anoosa.niri.enable {
    services = {
      dunst = {
        enable = true;

        settings = {
          global = {
            browser = "$BROWSER";
            follow = "mouse";
            format = "<b>%s</b>\\n%b";
            frame_width = 2;
            width = "370";
            height = "350";
            offset = "10x10";
            horizontal_padding = 8;
            icon_position = "off";
            line_height = 0;
            markup = "full";
            padding = 8;
            separator_height = 2;
            transparency = 10;
            word_wrap = true;
          };

          urgency_low = {
            timeout = 10;
          };

          urgency_normal = {
            timeout = 15;
          };

          urgency_critical = {
            timeout = 0;
          };
        };
      };
    };
  };
}
