{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.anoosa.transmission = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable transmission";
      example = true;
    };

    subdomain = lib.mkOption {
      type = lib.types.str;
      default = "torrent";
      description = "Subdomain to host transmission at";
      example = "torrent";
    };
  };

  config = lib.mkIf config.anoosa.transmission.enable {
    sops = {
      secrets = {
        "transmission/settings.json" = {
          owner = "transmission";
        };
      };
    };

    services = {
      nginx.virtualHosts = {
        "${config.anoosa.transmission.subdomain}.${config.anoosa.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          locations = {
            "/" = {
              proxyPass = "http://localhost:9091";
              proxyWebsockets = true;

              extraConfig = ''
                proxy_pass_header Authorization;
              '';
            };
          };
        };
      };

      transmission = {
        enable = true;
        webHome = pkgs.flood-for-transmission;
        package = pkgs.transmission_4;
        downloadDirPermissions = "770";
        credentialsFile = "/run/secrets/transmission/settings.json";

        settings = {
          umask = 007;
        };
      };
    };
  };
}
