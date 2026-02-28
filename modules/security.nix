{
  flake.nixosModules.security = {
    sops = {
      secrets = {
        "authelia/jwt" = {
          owner = "authelia-main";
        };

        "authelia/session" = {
          owner = "authelia-main";
        };

        "authelia/storage" = {
          owner = "authelia-main";
        };
      };
    };

    services = {
      authelia.instances.main = {
        enable = true;
        secrets = {
          storageEncryptionKeyFile = "/run/secrets/authelia/storage";
          jwtSecretFile = "/run/secrets/authelia/jwt";
          sessionSecretFile = "/run/secrets/authelia/session";
        };

        settings = {
          theme = "dark";
          default_2fa_method = "totp";

          server = {
            address = "tcp://127.0.0.1:9092/";
            headers = {
              csp_template = "default-src 'self'; style-src 'self' 'nonce-\${NONCE}' 'sha256-47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=' 'unsafe-inline' theme-park.dev raw.githubusercontent.com use.fontawesome.com; img-src 'self' theme-park.dev raw.githubusercontent.com data:; script-src 'self' 'unsafe-inline'; object-src 'none'; form-action 'self'; frame-ancestors 'self'; font-src use.fontawesome.com;";
            };
          };

          log = {
            level = "debug";
          };

          authentication_backend = {
            file = {
              path = "/var/lib/authelia-main/users_database.yml";
            };
          };

          access_control = {
            default_policy = "deny";
            rules = [
              {
                domain = [ "*.asherif.xyz" ];
                policy = "bypass";
              }
            ];
          };

          storage = {
            local = {
              path = "/var/lib/authelia-main/db.sqlite3";
            };
          };

          session = {
            name = "authelia_session";
            cookies = [
              {
                domain = "asherif.xyz";
                authelia_url = "https://auth.asherif.xyz";
              }
            ];
            expiration = "1h";
            inactivity = "5m";
            remember_me = "1M";
          };

          regulation = {
            max_retries = 3;
            find_time = "2m";
            ban_time = "5m";
          };

          notifier = {
            disable_startup_check = false;
            filesystem = {
              filename = "/var/lib/authelia-main/emails.txt";
            };
          };
        };
      };

      nginx.virtualHosts."auth.asherif.xyz" = {
        forceSSL = true;
        enableACME = true;
        acmeRoot = null;
        locations."/" = {
          proxyPass = "http://127.0.0.1:9092";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_set_header Accept-Encoding "";
            sub_filter '</head>' '<link rel="stylesheet" type="text/css" href="https://theme-park.dev/css/base/authelia/catppuccin-mocha.css"></head>';
            sub_filter_once on;
          '';
        };
      };
    };
  };
}
