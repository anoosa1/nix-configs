{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.anoosa.gitea = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable gitea";
      example = true;
    };

    subdomain = lib.mkOption {
      type = lib.types.str;
      default = "git";
      description = "Subdomain to host gitea at";
      example = "git";
    };
  };

  config = lib.mkIf config.anoosa.gitea.enable {
    services = {
      nginx.virtualHosts = {
        "${config.anoosa.gitea.subdomain}.${config.anoosa.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;

          locations = {
            "/" = {
              proxyPass = "http://unix:${config.services.gitea.settings.server.HTTP_ADDR}:/";
            };
          };
        };
      };

      gitea = {
        enable = true;

        settings = {
          server = {
            SSH_PORT = 222;
            PROTOCOL = "http+unix";
            ROOT_URL = "https://${config.anoosa.gitea.subdomain}.${config.anoosa.domain}";
            DOMIAIN = "${config.anoosa.gitea.subdomain}.${config.anoosa.domain}";
          };

          session = {
            COOKIE_SECURE = true;
          };

          service = {
            DISABLE_REGISTRATION = true;
          };
        };

        lfs = {
          enable = true;
        };

        database = {
          createDatabase = true;
          type = "postgres";
        };
      };
    };
  };
}
