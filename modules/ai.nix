{
  flake.nixosModules.ai = { pkgs, config, ... }: {
    sops.secrets."open-webui" = {
      owner = "root";
      mode = "0444";
    };

    services = {
      open-webui = {
        enable = true;
        host = "0.0.0.0";
        port = 3080;
        openFirewall = false;
        stateDir = "/var/lib/open-webui";
        environmentFile = "/run/secrets/open-webui";

        environment = {
          DEFAULT_USER_ROLE = "user";
          ENABLE_LOGIN_FORM = "false";
          ENABLE_OAUTH_ROLE_MANAGEMENT = "true";
          ENABLE_OAUTH_SIGNUP = "true";
          OAUTH_ADMIN_ROLES = "admin";
          OAUTH_CODE_CHALLENGE_METHOD = "S256";
          OAUTH_MERGE_ACCOUNTS_BY_EMAIL = "true";
          OAUTH_PROVIDER_NAME = "Authelia";
          OAUTH_ROLES_CLAIM = "groups";
          OAUTH_SCOPES = "openid profile email groups";
          OAUTH_USERNAME_CLAIM = "preferred_username";
          OPENID_PROVIDER_URL = "https://auth.asherif.xyz/.well-known/openid-configuration";
          WEBUI_NAME = "Soosa";
          WEBUI_URL = "https://chat.asherif.xyz";
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

    systemd.services.open-webui.serviceConfig = {
      LoadCredential = [ "open-webui-env:/run/secrets/open-webui" ];
      SupplementaryGroups = [ config.users.groups.keys.name ];
    };
  };
}
