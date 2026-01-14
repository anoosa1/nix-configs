{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.anoosa.nextcloud = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable nextcloud";
      example = true;
    };

    subdomain = lib.mkOption {
      type = lib.types.str;
      default = "hub";
      description = "Subdomain to host nextcloud at";
      example = "hub";
    };
  };

  config = lib.mkIf config.anoosa.nextcloud.enable {
    sops = {
      secrets = {
        "nextcloud/admin/password" = {
          owner = "nextcloud";
        };
      };
    };

    services = {
      nginx.virtualHosts = {
        "${config.anoosa.nextcloud.subdomain}.${config.anoosa.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
        };
      };

      nextcloud = {
        enable = true;
        package = pkgs.nextcloud32;
        hostName = "${config.anoosa.nextcloud.subdomain}.${config.anoosa.domain}";
        database.createLocally = true;
        configureRedis = true;
        maxUploadSize = "16G";
        https = true;

        settings = {
          default_phone_region = "CA";
          overwriteprotocol = "https";
        };

        config = {
          dbtype = "pgsql";
          adminuser = "admin";
          adminpassFile = "/run/secrets/nextcloud/admin/password";
        };
      };
    };
  };
}
