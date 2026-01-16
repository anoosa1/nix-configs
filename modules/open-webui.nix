{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.anoosa.open-webui = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable open-webui";
      example = true;
    };

    subdomain = lib.mkOption {
      type = lib.types.str;
      default = "chat";
      description = "Subdomain to host open-webui at";
      example = "chat";
    };
  };

  config = lib.mkIf config.anoosa.open-webui.enable {
    sops = {
      secrets = {
        "open-webui" = { };
      };
    };

    systemd.services.open-webui.serviceConfig.LoadCredential = "credentials:${config.sops.secrets.open-webui.path}";

    services = {
      nginx.virtualHosts = {
        "${config.anoosa.open-webui.subdomain}.${config.anoosa.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;

          locations = {
            "/" = {
              proxyPass = "http://localhost:${toString config.services.open-webui.port}";
              proxyWebsockets = true;
            };
          };
        };
      };

      open-webui = {
        enable = true;
        environmentFile = "/run/secrets/open-webui";

        environment = {
          WEBUI_NAME = "NoosaGPT";
          DEFAULT_USER_ROLE = "user";
          ENABLE_LOGIN_FORM = "false";
          ENABLE_OAUTH_GROUP_MANAGEMENT = "true";
          ENABLE_OAUTH_GROUP_CREATION = "true";
          ENABLE_OAUTH_SIGNUP = "true";
          ENABLE_SIGNUP = "false";
          ENABLE_WEB_SEARCH = "true";
          OAUTH_PROVIDER_NAME = "Authentik";
          OAUTH_USERNAME_CLAIM = "preferred_username";
          WEBUI_URL = "https://${config.anoosa.open-webui.subdomain}.${config.anoosa.domain}";
          WEB_SEARCH_ENGINE = "searxng";
        };
      };
    };
  };
}
