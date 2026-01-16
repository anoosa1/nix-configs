{
  lib,
  config,
  ...
}:
{
  options.anoosa.docling = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable docling";
      example = true;
    };

    subdomain = lib.mkOption {
      type = lib.types.str;
      default = "docling";
      description = "Subdomain to host docling at";
      example = "docling";
    };
  };

  config = lib.mkIf config.anoosa.docling.enable {
    services = {
      nginx.virtualHosts = {
        "${config.anoosa.docling.subdomain}.${config.anoosa.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;

          locations = {
            "/" = {
              proxyPass = "http://localhost:${toString config.services.docling-serve.port}";
              proxyWebsockets = true;
            };
          };
        };
      };

      docling-serve = {
        enable = true;
      };
    };
  };
}
