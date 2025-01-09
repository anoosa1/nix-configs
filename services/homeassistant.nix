{
  pkgs,
  sops,
  ...
}:

{
  sops = {
    secrets = {
      "nextcloud/admin/password" = {
        owner = "nextcloud";
      };
      "cloudflare" = {
        owner = "acme";
      };
    };
  };

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
      package = (pkgs.home-assistant.override {
        extraPackages = py: with py; [ psycopg2 ];
      }).overrideAttrs (oldAttrs: {
        doInstallCheck = false;
      });
      extraComponents = [
        "met"
        "esphome"
        "radio_browser"
        "google_translate"
        "isal"
        "ffmpeg"
        "tts"
        "http"
        "websocket_api"
        "auth"
        "backup"
        "shopping_list"
        "analytics"
        "mobile_app"
      ];
      config = {
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
