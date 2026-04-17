{
  flake.nixosModules.ai = { pkgs, ... }: {
    sops = {
      secrets = {
        open-webui = {
          owner = "open-webui";
        };
      };
    };

    services = {
      open-webui = {
        enable = true;
        environmentFile = "/run/secrets/open-webui";

        environment = {
          WEBUI_URL = "https://chat.asherif.xyz";
          PORT = "3080";
          ENABLE_OAUTH_SIGNUP = "true";
          OAUTH_MERGE_ACCOUNTS_BY_EMAIL = "true";
          OPENID_PROVIDER_URL = "https://auth.asherif.xyz/.well-known/openid-configuration";
          OAUTH_PROVIDER_NAME = "asherif.xyz";
          OAUTH_SCOPES = "openid email profile groups";
          ENABLE_OAUTH_ROLE_MANAGEMENT = "true";
          OAUTH_ADMIN_ROLES = "admin";
          OAUTH_ROLES_CLAIM = "groups";
          OAUTH_CODE_CHALLENGE_METHOD = "S256";
        };
      };
      
      nginx = {
        virtualHosts = {
          "chat.asherif.xyz" = {
            forceSSL = true;
            enableACME = true;
            acmeRoot = null;
            locations."/" = {
              proxyPass = "http://localhost:3080";
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

      #tts = {
      #  servers = {
      #    english = {
      #      enable = true;
      #      port = 5300;
      #      model = "tts_models/en/ljspeech/tacotron2-DDC";
      #    };
      #  };
      #};
    };
  };
}
