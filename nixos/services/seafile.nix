{
  services = {
    nginx.virtualHosts = {
      "files.asherif.xyz" = {
        forceSSL = true;
        enableACME = true;
        acmeRoot = null;
        locations = {
          "/" = {
            proxyPass = "http://unix:/run/seahub/gunicorn.sock";
            proxyWebsockets = true;
            extraConfig = ''
              proxy_set_header   Host $host;
              proxy_set_header   X-Real-IP $remote_addr;
              proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header   X-Forwarded-Host $server_name;
              proxy_read_timeout  1200s;
              client_max_body_size 10G;
            '';
          };

          "seafhttp" = {
            proxyPass = "http://unix:/run/seafile/server.sock";
            extraConfig = ''
              rewrite ^/seafhttp(.*)$ $1 break;
              client_max_body_size 0;
              proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_connect_timeout  36000s;
              proxy_read_timeout  36000s;
              proxy_send_timeout  36000s;
              send_timeout  36000s;
            '';
          };
        };
      };
    };

    seafile = {
      enable = true;
      adminEmail = "anas@asherif.xyz";

      seahubExtraConf = ''
        ENABLE_OAUTH = True
        OAUTH_CLIENT_ID = "nMCbEDaZmLK4x4hpBQD7lQ2vZ723JZUYwwqQLbqc"
        OAUTH_CLIENT_SECRET = "gMEUD3iAD0JdN4iBj0Pahw2PjvNbuAqfyflFpVHFAxN9RN3iIFgR1qOqWV0ajS98KSTdBFT9RwZmUyMS1jm56HLTRfU6BQ3t9RDkwnSuqJZFJZfL9ei3xgsk70aEvVJQ"
        OAUTH_REDIRECT_URL = 'https://files.asherif.xyz/oauth/callback/'
        OAUTH_PROVIDER = 'authentik' 
        OAUTH_AUTHORIZATION_URL = 'https://accounts.asherif.xyz/application/o/authorize/'
        OAUTH_TOKEN_URL = 'https://accounts.asherif.xyz/application/o/token/'
        OAUTH_USER_INFO_URL = 'https://accounts.asherif.xyz/application/o/userinfo/'
        OAUTH_SCOPE = ["user",]
        OAUTH_ATTRIBUTE_MAP = {
            "uid": (True, "preferred_username")
            "name": (False, "name"),
            "email": (False, "email"),
        }
        ALLOWED_HOSTS = ['files.asherif.xyz']
        CSRF_COOKIE_SECURE = True
        CSRF_COOKIE_SAMESITE = 'Strict'
        CSRF_TRUSTED_ORIGINS = ['https://files.asherif.xyz']
      '';

      seafileSettings = {
        use_go_fileserver = true;

        fileserver = {
          host = "unix:/run/seafile/server.sock";
        };
      };

      ccnetSettings = {
        General = {
          SERVICE_URL = "https://files.asherif.xyz";
        };
      };

      gc = {
        enable = true;
        dates = [ "Sun 03:00:00" ];
      };
    };
  };
}
