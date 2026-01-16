{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.anoosa.lobechat = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable lobechat";
      example = true;
    };

    subdomain = lib.mkOption {
      type = lib.types.str;
      default = "chat";
      description = "Subdomain to host lobechat at";
      example = "chat";
    };
  };

  config = lib.mkIf config.anoosa.lobechat.enable {
    sops = {
      secrets = {
        "lobechat" = { };
      };
    };

    services = {
      nginx.virtualHosts = {
        "${config.anoosa.lobechat.subdomain}.${config.anoosa.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;

          locations = {
            "/" = {
              proxyPass = "http://localhost:${toString config.services.lobechat.port}";
              proxyWebsockets = true;
            };
          };
        };
      };

      virtualisation = {
        docker = {
          enable = true;
        };

        oci-containers = {
          backend = "docker";

          containers = {
            lobechat = {
              image = "lobehub/lobe-chat";
              hostname = "lobechat";

              environment = {
                OPENAI_PROXY_URL = "https://generativelanguage.googleapis.com/v1beta/openai";
              };

              environmentFiles = [
                /run/secrets/lobechat
              ];

              ports = [
                "3210:3210"
              ];
            };
          };
        };
      };
    };
  };
}
