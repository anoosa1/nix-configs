{
  services = {
    nginx.virtualHosts = {
      "home.asherif.xyz" = {
        forceSSL = true;
        enableACME = true;
        acmeRoot = null;
        locations."/" = {
          proxyPass = "http://localhost:8123";
          proxyWebsockets = true;
        };
        extraConfig = ''
          proxy_buffering off;
        '';
      };
    };

    postgresql = {
      ensureDatabases = [ "hass" ];
      ensureUsers = [{
        name = "hass";
        ensureDBOwnership = true;
      }];
    };

    home-assistant = {
      enable = true;

      extraComponents = [
        "analytics"
        "auth"
        "backup"
        "esphome"
        "ffmpeg"
        "google_translate"
        "homekit"
        "homekit_controller"
        "http"
        "isal"
        "met"
        "mobile_app"
        "radio_browser"
        "shopping_list"
        "tts"
        "websocket_api"
      ];

      extraPackages = python3Packages: with python3Packages; [
        psycopg2
      ];

      config = {
        default_config = {};

        http = {
          server_host = "127.0.0.1";
          trusted_proxies = [ "127.0.0.1" ];
          use_x_forwarded_for = true;
        };

        recorder = {
          db_url = "postgresql://@/hass";
        };
      };
    };
  };
}
