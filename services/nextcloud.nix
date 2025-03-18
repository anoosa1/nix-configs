{
  pkgs,
  sops,
  ...
}:

{
  sops = {
    secrets = {
      "nextcloud/admin/password" = {
        owner = "nextcloud";
      };
      "cloudflare" = {
        owner = "acme";
      };
    };
  };

  security = {
    acme = {
      acceptTerms = true;
      defaults = {
        email = "anas@asherif.xyz";
        dnsProvider = "cloudflare";
        dnsResolver = "1.1.1.1:53";
        dnsPropagationCheck = true;
        credentialFiles = {
          "CF_DNS_API_TOKEN_FILE" = "/run/secrets/cloudflare";
        };
      };
    };
  };

  services = {
    nginx.virtualHosts = {
      "hub.asherif.xyz" = {
        forceSSL = true;
        enableACME = true;
        acmeRoot = null;
      };
    };
    nextcloud = {
      enable = true;
      package = pkgs.nextcloud31;
      hostName = "hub.asherif.xyz";
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
}
