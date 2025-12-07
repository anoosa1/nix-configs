{
  lib,
  config,
  ...
}:
{
  options.anoosa.vaultwarden = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable vaultwarden";
      example = true;
    };

    subdomain = lib.mkOption {
      type = lib.types.str;
      default = "passwords";
      description = "Subdomain to host vaultwarden at";
      example = "passwords";
    };
  };

  config = lib.mkIf config.anoosa.vaultwarden.enable {
    sops = {
      secrets = {
        "vaultwarden" = {
          owner = "vaultwarden";
        };
      };
    };

    services = {
      nginx.virtualHosts = {
        "${config.anoosa.vaultwarden.subdomain}.${config.anoosa.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;

          locations = {
            "/" = {
              proxyPass = "http://localhost:${toString config.services.vaultwarden.config.ROCKET_PORT}";
              proxyWebsockets = true;
            };
          };
        };
      };

      vaultwarden = {
        enable = true;
        dbBackend = "postgresql";
        environmentFile = "/run/secrets/vaultwarden";

        config = {
          DATABASE_URL = "postgresql://vaultwarden@/vaultwarden";
          DOMAIN = "https://${config.anoosa.vaultwarden.subdomain}.${config.anoosa.domain}";
          EMAIL_CHANGE_ALLOWED = "false";
          EMAIL_EXPIRATION_TIME = "300";
          ROCKET_PORT = "29486";
          SIGNUPS_ALLOWED = "false";
          SMTP_PORT = "587";
          SMTP_SECURITY = "starttls";
          SSO_CLIENT_CACHE_EXPIRATION = "0";
          SSO_ENABLED = "true";
          SSO_ONLY = "true";
          SSO_SCOPES="openid email profile offline_access";
        };
      };

      postgresql = {
        ensureDatabases = [ "vaultwarden" ];

        ensureUsers = [
          {
            name = "vaultwarden";
            ensureDBOwnership = true;
          }
        ];
      };
    };
  };
}
