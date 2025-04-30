{
  pkgs,
  sops,
  ...
}:

{
  sops = {
    secrets = {
      "paperless/environment" = {
        owner = "paperless";
      };
    };
  };

  services = {
    nginx.virtualHosts = {
      "docs.asherif.xyz" = {
        forceSSL = true;
        enableACME = true;
        acmeRoot = null;
        locations."/docs" = {
          proxyPass = "http://localhost:28981";  
          proxyWebsockets = true;
          extraConfig = "proxy_pass_header Authorization;";
        };
      };
    };

    paperless = {
      enable = true;
      #environmentFile = "/run/secrets/paperless/environment";

      settings = {
        PAPERLESS_URL = "https://docs.asherif.xyz";
        PAPERLESS_FORCE_SCRIPT_NAME = "/docs";
        PAPERLESS_STATIC_URL = "/docs/static/";
        PAPERLESS_APPS = "allauth.socialaccount.providers.openid_connect";
      };

      database = {
        createLocally = true;
      };

      exporter = {
        enable = true;
      };
    };
  };
}
