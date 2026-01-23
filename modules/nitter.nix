{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.anoosa.nitter = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable nitter";
      example = true;
    };

    subdomain = lib.mkOption {
      type = lib.types.str;
      default = "x";
      description = "Subdomain to host nitter at";
      example = "x";
    };
  };

  config = lib.mkIf config.anoosa.nitter.enable {
    sops = {
      secrets = {
        "nitter" = {
          mode = "0444";
        };
      };
    };

    services = {
      nginx.virtualHosts = {
        "${config.anoosa.nitter.subdomain}.${config.anoosa.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;

          locations = {
            "/" = {
              proxyPass = "http://localhost:${toString config.services.nitter.server.port}";
            };
          };
        };
      };

      nitter = {
        enable = true;
        sessionsFile = "/run/secrets/nitter";

        server = {
          port = 59181;
          https = true;
          hostname = "${config.anoosa.nitter.subdomain}.${config.anoosa.domain}";
        };

        preferences = {
          squareAvatars = true;
          replaceTwitter = "${config.anoosa.nitter.subdomain}.${config.anoosa.domain}";
          infiniteScroll = true;
          hlsPlayback = true;
        };
      };
    };
  };
}
