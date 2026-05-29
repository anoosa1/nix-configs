{
  flake.nixosModules.ai = { pkgs, ... }: {
    sops = {
      secrets = {
        "open-webui" = {
          owner = "open-webui";
        };
      };
    };

    services = {
      open-webui = {
        enable = true;
        host = "127.0.0.1";
        port = 3080;
        openFirewall = false;
        stateDir = "/var/lib/open-webui";
        environmentFile = "/run/secrets/open-webui";

        environment = {
          WEBUI_URL = "https://chat.asherif.xyz";

          # OIDC with Authelia
          ENABLE_OAUTH_SIGNUP = "true";
          OAUTH_MERGE_ACCOUNTS_BY_EMAIL = "true";
          OAUTH_PROVIDER_NAME = "Authelia";
          OAUTH_SCOPES = "openid email profile groups";
          OAUTH_CODE_CHALLENGE_METHOD = "S256";

          OPENID_PROVIDER_URL = "https://auth.asherif.xyz/.well-known/openid-configuration";

          # Role mapping via Authelia groups claim
          ENABLE_OAUTH_ROLE_MANAGEMENT = "true";
          OAUTH_ADMIN_ROLES = "admin";
          OAUTH_ROLES_CLAIM = "groups";
        };
      };

      nginx = {
        virtualHosts = {
          "chat.asherif.xyz" = {
            forceSSL = true;
            enableACME = true;
            acmeRoot = null;

            locations."/" = {
              proxyPass = "http://127.0.0.1:3080";
              proxyWebsockets = true;
              extraConfig = ''
                proxy_set_header Host $host;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Proto $scheme;
              '';
            };
          };
        };
      };
    };
  };
}
