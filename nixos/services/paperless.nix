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
        locations."/" = {
          proxyPass = "http://localhost:28981";  
          proxyWebsockets = true;
          extraConfig = "proxy_set_header Host $host;";
        };
      };
    };

    paperless = {
      enable = true;
      environmentFile = "/run/secrets/paperless/environment";

      settings = {
        PAPERLESS_APPS = "allauth.socialaccount.providers.openid_connect";
        PAPERLESS_DISABLE_REGULAR_LOGIN = true;
        PAPERLESS_EMAIL_PARSE_DEFAULT_LAYOUT = 2;
        PAPERLESS_TIME_ZONE = "America/Toronto";
        #PAPERLESS_EMPTY_TRASH_DIR = "../media/trash";
        PAPERLESS_LOGOUT_REDIRECT_URL = "https://accounts.asherif.xyz/application/o/paperless-ngx/end-session/";
        PAPERLESS_OAUTH_CALLBACK_BASE_URL = "https://docs.asherif.xyz";
        PAPERLESS_REDIRECT_LOGIN_TO_SSO = true;
        PAPERLESS_SOCIAL_ACCOUNT_SYNC_GROUPS = true;
        PAPERLESS_SOCIAL_AUTO_SIGNUP = true;
        PAPERLESS_TIKA_ENABLED = true;
        PAPERLESS_URL = "https://docs.asherif.xyz";
        PAPERLESS_USE_X_FORWARD_HOST = true;
        PAPERLESS_USE_X_FORWARD_PORT = true;
      };

      database = {
        createLocally = true;
      };

      exporter = {
        enable = true;
      };
    };

    tika = {
      enable = true;
    };

    gotenberg = {
      enable = true;
    };
  };
}
