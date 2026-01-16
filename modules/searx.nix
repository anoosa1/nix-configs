{
  lib,
  config,
  ...
}:
{
  options.anoosa.searx = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable searx";
      example = true;
    };

    subdomain = lib.mkOption {
      type = lib.types.str;
      default = "search";
      description = "Subdomain to host searx at";
      example = "search";
    };
  };

  config = lib.mkIf config.anoosa.searx.enable {
    sops = {
      secrets = {
        "searx" = {
          owner = "searx";
        };
      };
    };

    services = {
      nginx.virtualHosts = {
        "${config.anoosa.searx.subdomain}.${config.anoosa.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;

          locations = {
            "/" = {
              recommendedProxySettings = true;
              recommendedUwsgiSettings = true;
              uwsgiPass = "unix:${config.services.uwsgi.instance.vassals.searx.socket}";
              extraConfig =
              ''
                  uwsgi_param  HTTP_HOST             $host;
                  uwsgi_param  HTTP_CONNECTION       $http_connection;
                  uwsgi_param  HTTP_X_SCHEME         $scheme;
                  uwsgi_param  HTTP_X_SCRIPT_NAME    "";
                  uwsgi_param  HTTP_X_REAL_IP        $remote_addr;
                  uwsgi_param  HTTP_X_FORWARDED_FOR  $proxy_add_x_forwarded_for;
              '';
            };

            "/static/".alias = lib.mkDefault "${config.services.searx.package}/share/static/";
          };
        };
      };

      searx = {
        enable = true;
        configureNginx = true;
        configureUwsgi = true;
        domain = "${config.anoosa.searx.subdomain}.${config.anoosa.domain}";
        environmentFile = "/run/secrets/searx";
        redisCreateLocally = true;

        settings = {
          server = {
            secret_key = "$SEARX_SECRET_KEY";
          };

          search = {
            formats = [
              "html"
              "csv"
              "json"
              "rss"
            ];
          };
        };

        uwsgiConfig = {
          socket = "/run/searx/searx.sock";
          chmod-socket = "660";
        };
      };
    };
  };
}
