{
  services = {
    nginx.virtualHosts = {
      "news.asherif.xyz" = {
        forceSSL = true;
        enableACME = true;
        acmeRoot = null;
        locations."/" = {
          proxyPass = "http://localhost:1209";
          proxyWebsockets = true;
          extraConfig = "proxy_set_header Host $host;";
        };
      };
    };

    miniflux = {
      enable = true;
      createDatabaseLocally = true;

      config = {
        LISTEN_ADDR = "localhost:1209";
        OAUTH2_PROVIDER = "oidc";
        OAUTH2_CLIENT_ID = "YkZM5cBgHPqTtYJGTjrr3Zl8FT9W4jqEWJVqxS1h";
        OAUTH2_CLIENT_SECRET = "0XmBzXqMWn2eTnzgv9i4A9ObyAANlY1RhRQeWYs6MjgWNl0H6NRqUXsn8mx0W1eeOpEjefOEnMIqmtmCmkvvYrTap8k4gCYhkXrl9WOHeEkKriQmh6rWcxFkNUvbphrs";
        OAUTH2_REDIRECT_URL = "https://news.asherif.xyz/oauth2/oidc/callback";
        OAUTH2_OIDC_DISCOVERY_ENDPOINT = "https://accounts.asherif.xyz/application/o/miniflux/";
        OAUTH2_USER_CREATION = 1;
      };
    };
  };
}
