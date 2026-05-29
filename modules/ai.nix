{
  flake.nixosModules.ai = { pkgs, ... }: {
    sops = {
      secrets = {
        "open-webui" = {
          owner = "root";
          mode = "0444";
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
          ENABLE_OAUTH_SIGNUP=***          OAUTH_MERGE_ACCOUNTS_BY_EMAIL=***          OAUTH_PROVIDER_NAME=***          OAUTH_SCOPES=*** email profile groups";
          OAUTH_CODE_CHALLENGE_METHOD=***          OPENID_PROVIDER_URL = "https://auth.asherif.xyz/.well-known/openid-configuration";

          # Role mapping via Authelia groups claim
          ENABLE_OAUTH_ROLE_MANAGEMENT=***          OAUTH_ADMIN_ROLES=***          OAUTH_ROLES_CLAIM=***        };
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

    # LoadCredential mounts the sops env file inside the DynamicUser sandbox
    systemd.services.open-webui = {
      serviceConfig.LoadCredential = [ "open-webui-env:/run/secrets/open-webui" ];
    };
  };
}
