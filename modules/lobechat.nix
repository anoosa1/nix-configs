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

    boot.kernel.sysctl = {
      "net.ipv4.ip_unprivileged_port_start" = 0;
    };

    virtualisation = {
      docker = {
        enable = true;
      };

      oci-containers = {
        backend = "docker";

        containers = {
          lobechat = {
            image = "lobehub/lobe-chat:latest";
 
            environment = {
              OPENAI_PROXY_URL = "https://generativelanguage.googleapis.com/v1beta/openai";
              APP_URL = "https://chat.asherif.xyz";
            };
 
            environmentFiles = [
              /run/secrets/lobechat
            ];
 
            ports = [
              "127.0.0.1:3210:3210"
            ];
          };
        };
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
              proxyPass = "http://localhost:3210";
              proxyWebsockets = true;
            };
          };
        };
      };
    };
  };
}
