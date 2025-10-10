{
  lib,
  config,
  ...
}:
{
  options.anoosa.immich = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable immich";
      example = true;
    };

    subdomain = lib.mkOption {
      type = lib.types.str;
      default = "photos";
      description = "Subdomain to host immich at";
      example = "photos";
    };
  };

  config = lib.mkIf config.anoosa.immich.enable {
    services = {
      nginx.virtualHosts = {
        "${config.anoosa.immich.subdomain}.${config.anoosa.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;

          locations = {
            "/" = {
              proxyPass = "http://localhost:${toString config.services.immich.port}";
              proxyWebsockets = true;

              extraConfig = ''
                proxy_pass_header Authorization;
                client_max_body_size 10G;
              '';
            };
          };
        };
      };

      immich = {
        enable = true;
      };
    };
  };
}
