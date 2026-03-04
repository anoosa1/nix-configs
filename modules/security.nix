{
  flake.nixosModules.security = { config, ... }: {
    sops = {
      secrets = {
        "authelia/anas" = {
          owner = "authelia-main";
        };

        "authelia/clients.yml" = {
          owner = "authelia-main";
        };

        "authelia/hmac" = {
          owner = "authelia-main";
        };

        "authelia/jwt" = {
          owner = "authelia-main";
        };

        "authelia/key" = {
          owner = "authelia-main";
        };

        "authelia/session" = {
          owner = "authelia-main";
        };

        "authelia/storage" = {
          owner = "authelia-main";
        };

        "vaultwarden" = {
          owner = "vaultwarden";
        };
      };

      templates."users_database.yml" = {
        owner = "authelia-main";
        content = ''
          users:
            anas:
              displayname: "Anas"
              password: "${config.sops.placeholder."authelia/anas"}"
              email: "anas@asherif.xyz"
              groups:
                - admin
        '';
      };
    };

    services = {
      authelia.instances.main = {
        enable = true;

        secrets = {
          jwtSecretFile = "/run/secrets/authelia/jwt";
          oidcHmacSecretFile = "/run/secrets/authelia/hmac";
          oidcIssuerPrivateKeyFile = "/run/secrets/authelia/key";
          sessionSecretFile = "/run/secrets/authelia/session";
          storageEncryptionKeyFile = "/run/secrets/authelia/storage";
        };

        settingsFiles = [
          "/run/secrets/authelia/clients.yml"
        ];

        settings = {
          theme = "dark";
          default_2fa_method = "webauthn";

          server = {
            address = "tcp://127.0.0.1:9092/";
            headers = {
              csp_template = "default-src 'self'; style-src 'self' 'nonce-\${NONCE}' 'sha256-47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=' 'unsafe-inline' theme-park.dev raw.githubusercontent.com use.fontawesome.com; img-src 'self' theme-park.dev raw.githubusercontent.com data:; script-src 'self' 'unsafe-inline'; object-src 'none'; form-action 'self'; frame-ancestors 'self'; font-src use.fontawesome.com;";
            };
          };

          identity_providers = {
            oidc = {
              lifespans = {
                access_token = "1h";
                authorize_code = "1m";
                id_token = "1h";
                refresh_token = "90m";
              };

              cors = {
                allowed_origins_from_client_redirect_uris = false;

                endpoints = [
                  "authorization"
                  "token"
                  "revocation"
                  "introspection"
                ];

                allowed_origins = [
                  "https://*.asherif.xyz"
                ];
              };
            };
          };

          webauthn = {
            disable = false;
            enable_passkey_login = false;
            display_name = "asherif.xyz";
            attestation_conveyance_preference = "direct";
          };

          totp = {
            disable = false;
            issuer = "asherif.xyz";
            algorithm = "sha512";
          };

          log = {
            level = "debug";
          };

          authentication_backend = {
            file = {
              path = config.sops.templates."users_database.yml".path;
            };
          };

          access_control = {
            default_policy = "two_factor";
            rules = [
              {
                domain = [ "*.asherif.xyz" ];
                policy = "two_factor";
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

      nginx.virtualHosts = {
        "auth.asherif.xyz" = {
          acmeRoot = null;
          enableACME = true;
          forceSSL = true;

          locations = {
            "/" = {
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

        "passwords.asherif.xyz" = {
          acmeRoot = null;
          enableACME = true;
          forceSSL = true;
        };
      };

      vaultwarden = {
        enable = true;
        configureNginx = true;
        configurePostgres = true;
        dbBackend = "postgresql";
        domain = "passwords.asherif.xyz";
        environmentFile = "/run/secrets/vaultwarden";

        config = {
          EMAIL_CHANGE_ALLOWED = "false";
          EMAIL_EXPIRATION_TIME = "300";
          SIGNUPS_ALLOWED = "false";
          SIGNUPS_DOMAINS_WHITELIST = "asherif.xyz";
          SMTP_PORT = "587";
          SMTP_SECURITY = "starttls";
          SSO_AUTHORITY = "https://auth.asherif.xyz";
          SSO_AUTH_ONLY_NOT_SESSION = true;
          SSO_CLIENT_ID = "vaultwarden";
          SSO_ENABLED = "true";
          SSO_ONLY = "true";
          SSO_SCOPES = "email profile offline_access";
        };
      };
    };
  };
}
