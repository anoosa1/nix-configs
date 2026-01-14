{
  lib,
  config,
  ...
}:
{
  options.anoosa.website = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable personal website";
      example = true;
    };

    dir = lib.mkOption {
      type = lib.types.path;
      default = "/srv/website";
      description = "Path to site";
      example = "/srv/website";
    };
  };

  config = lib.mkIf config.anoosa.paperless.enable {
    services = {
      nginx.virtualHosts = {
        "${config.anoosa.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          root = "/srv/asherif.xyz";

          listen = [{
            addr = "0.0.0.0";
            port = 444;
            ssl = true;
          }];
        };
      };
    };
  };
}
