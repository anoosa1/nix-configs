{
  inputs,
  self,
  ...
}:
{
  flake.nixosModules.server = { lib, config, pkgs, ... }: {
    options = {
      anoosa = {
        domain = lib.mkOption {
          type = lib.types.str;
          default = "asherif.xyz";
          description = "Domain name for services";
          example = "example.org";
        };

        "4get" = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Enable 4get";
            example = true;
          };

          subdomain = lib.mkOption {
            type = lib.types.str;
            default = "search";
            description = "Subdomain to host 4get at";
            example = "search";
          };
        };

        code-server = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Enable code-server";
            example = true;
          };

          subdomain = lib.mkOption {
            type = lib.types.str;
            default = "code";
            description = "Subdomain to host code-server at";
            example = "code";
          };
        };

        gitea = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Enable gitea";
            example = true;
          };
  
          subdomain = lib.mkOption {
            type = lib.types.str;
            default = "git";
            description = "Subdomain to host gitea at";
            example = "git";
          };
        };

        home-assistant = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Enable home-assistant";
            example = true;
          };

          subdomain = lib.mkOption {
            type = lib.types.str;
            default = "home";
            description = "Subdomain to host home-assistant at";
            example = "home";
          };
        };

        immich = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Enable immich";
            example = true;
          };

          subdomain = lib.mkOption {
            type = lib.types.str;
            default = "photos";
            description = "Subdomain to host immich at";
            example = "photos";
          };
        };

        librechat = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Enable librechat";
            example = true;
          };

          subdomain = lib.mkOption {
            type = lib.types.str;
            default = "librechat";
            description = "Subdomain to host librechat at";
            example = "librechat";
          };
        };

        nextcloud = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Enable nextcloud";
            example = true;
          };

          subdomain = lib.mkOption {
            type = lib.types.str;
            default = "hub";
            description = "Subdomain to host nextcloud at";
            example = "hub";
          };
        };

        nitter = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Enable nitter";
            example = true;
          };

          subdomain = lib.mkOption {
            type = lib.types.str;
            default = "x";
            description = "Subdomain to host nitter at";
            example = "x";
          };
        };

        paperless = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Enable paperless";
            example = true;
          };

          subdomain = lib.mkOption {
            type = lib.types.str;
            default = "docs";
            description = "Subdomain to host paperless at";
            example = "docs";
          };
        };

        soft-serve = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Enable soft-serve";
            example = true;
          };
        };

        transmission = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Enable transmission";
            example = true;
          };

          subdomain = lib.mkOption {
            type = lib.types.str;
            default = "torrent";
            description = "Subdomain to host transmission at";
            example = "torrent";
          };
        };

        vaultwarden = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Enable vaultwarden";
            example = true;
          };

          subdomain = lib.mkOption {
            type = lib.types.str;
            default = "passwords";
            description = "Subdomain to host vaultwarden at";
            example = "passwords";
          };
        };
      };
    };

    config = lib.mkMerge [
      {
        imports = [
          inputs.sops-nix.nixosModules.sops
        ];

        ## sops
        sops = {
          defaultSopsFile = "${inputs.secrets}/secrets.yaml";
          defaultSopsFormat = "yaml";
          age = {
            keyFile = "/home/anas/.local/etc/sops/age/keys.txt";
          };
        };
      }

      lib.mkIf config.anoosa."4get".enable {
        systemd.services."phpfpm-4get".serviceConfig = {
          ReadOnlyPaths = [ "/nix/store" ];
          ReadWritePaths = [ "/var/lib/4get" ];

          BindPaths = [
            "/var/lib/4get/icons:${pkgs."4get"}/share/4get/icons"
          ];
        };

        services = {
          nginx.virtualHosts = {
            "${config.anoosa."4get".subdomain}.${config.anoosa.domain}" = {
              root = "${self.packages.${pkgs.system}."4get"}/share/4get";
              forceSSL = true;
              enableACME = true;
              acmeRoot = null;

              locations = {
                "/" = {
                  index = "index.php";
                  tryFiles = "$uri $uri/ $uri.php$is_args$query_string";
                };

                "/icons/" = {
                  alias = "/var/lib/4get/icons/";
                  extraConfig = "allow all;";
                };

                "~ \\.php$" = {
                  tryFiles = "$uri $uri/ $uri.php$is_args$query_string";

                  extraConfig = ''
                    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
                    
                    fastcgi_pass unix:${config.services.phpfpm.pools."4get".socket};
                    fastcgi_index index.php;
                    fastcgi_buffer_size 128k;
                    fastcgi_buffers 4 256k;
                    fastcgi_busy_buffers_size 256k;
                    include ${pkgs.nginx}/conf/fastcgi_params;
                  '';
                };
              };
            };
          };

          phpfpm.pools."4get" = {
            user = "nginx";
            group = "nginx";

            phpPackage = pkgs.php83.withExtensions ({ all, ... }: with all; [
              apcu
              fileinfo
              curl
              gd
              mbstring
              opcache
              imagick
              zlib
              openssl
              sodium
              filter
            ]);

            settings = {
              "listen.owner" = "nginx";
              "listen.group" = "nginx";
              "pm" = "dynamic";
              "pm.max_children" = 32;
              "pm.start_servers" = 2;
              "pm.min_spare_servers" = 2;
              "pm.max_spare_servers" = 4;
              "php_admin_value[apc.enabled]" = "1";
              "php_admin_value[apc.shm_size]" = "32M";
            };
          };
        };
      }

      lib.mkIf config.anoosa.code-server.enable {
        users = {
          users = {
            code-server = {
              homeMode = "700";

              openssh.authorizedKeys.keys = [
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHhK2hN/aKRr12GA6dklSQbL+jG5iQ9OuvXzprvzfGc8 anas@apollo"
              ];
            };
          };
        };

        services = {
          nginx.virtualHosts = {
            "${config.anoosa.code-server.subdomain}.${config.anoosa.domain}" = {
              forceSSL = true;
              enableACME = true;
              acmeRoot = null;
              locations."/" = {
                proxyPass = "http://unix:/run/code-server/code-server.sock:/";
                proxyWebsockets = true;
                extraConfig = "proxy_pass_header Authorization;";
              };
            };
          };

          code-server = {
            enable = true;
            userDataDir = "/home/code-server";
            socketMode = "777";
            socket = "/run/code-server/code-server.sock";
            hashedPassword = "$argon2i$v=19$m=4096,t=3,p=1$MkI1SVNweE9YSFZwcmhLSmpVU0VwdnlpcE0wPQ$d7GsnTEdz2npQoZqTgjodvAGz9aPMNsRorbbL+421JY";
            proxyDomain = "code.asherif.xyz";
            disableWorkspaceTrust = true;
            disableUpdateCheck = true;
            disableTelemetry = true;
            disableGettingStartedOverride = true;

            package = pkgs.vscode-with-extensions.override {
              vscode = pkgs.code-server;
              vscodeExtensions = with pkgs.vscode-extensions; [
                asvetliakov.vscode-neovim
                bbenoist.nix
                Google.gemini-cli-vscode-ide-companion
                jdinhlife.gruvbox
                llvm-vs-code-extensions.vscode-clangd
                ms-dotnettools.csharp
                ms-python.python
              ];
            };

            extraPackages = [
              pkgs.gemini-cli
              pkgs.neovim
            ];
          };
        };
      }

      lib.mkIf config.anoosa.gitea.enable {
        services = {
          nginx.virtualHosts = {
            "${config.anoosa.gitea.subdomain}.${config.anoosa.domain}" = {
              forceSSL = true;
              enableACME = true;
              acmeRoot = null;
  
              locations = {
                "/" = {
                  proxyPass = "http://unix:${config.services.gitea.settings.server.HTTP_ADDR}:/";
                };
              };
            };
          };
  
          gitea = {
            enable = true;
  
            settings = {
              server = {
                SSH_PORT = 222;
                PROTOCOL = "http+unix";
                ROOT_URL = "https://${config.anoosa.gitea.subdomain}.${config.anoosa.domain}";
                DOMIAIN = "${config.anoosa.gitea.subdomain}.${config.anoosa.domain}";
              };
  
              session = {
                COOKIE_SECURE = true;
              };
  
              service = {
                DISABLE_REGISTRATION = true;
              };
            };
  
            lfs = {
              enable = true;
            };
  
            database = {
              createDatabase = true;
              type = "postgres";
            };
          };
        };
      }

      lib.mkIf config.anoosa.home-assistant.enable {
        services = {
          nginx.virtualHosts = {
            "${config.anoosa.home-assistant.subdomain}.${config.anoosa.domain}" = {
              forceSSL = true;
              enableACME = true;
              acmeRoot = null;
              locations."/" = {
                proxyPass = "http://localhost:${toString config.services.home-assistant.config.http.server_port}";
                proxyWebsockets = true;
              };

              extraConfig = ''
                proxy_buffering off;
              '';
            };
          };

          postgresql = {
            ensureDatabases = [ "hass" ];
            ensureUsers = [{
              name = "hass";
              ensureDBOwnership = true;
            }];
          };

          home-assistant = {
            enable = true;

            extraComponents = [
              "analytics"
              "auth"
              "backup"
              "esphome"
              "ffmpeg"
              "homekit_controller"
              "http"
              "isal"
              "media_player"
              "met"
              "mobile_app"
              "radio_browser"
              "tts"
              "websocket_api"
            ];

            extraPackages = python3Packages: with python3Packages; [
              psycopg2
            ];

            config = {
              default_config = {};

              http = {
                server_host = "127.0.0.1";
                trusted_proxies = [ "127.0.0.1" ];
                use_x_forwarded_for = true;
              };

              recorder = {
                db_url = "postgresql://@/hass";
              };
            };
          };
        };
      }

      lib.mkIf config.anoosa.immich.enable {
        services = {
          nginx.virtualHosts = {
            "${config.anoosa.immich.subdomain}.${config.anoosa.domain}" = {
              forceSSL = true;
              enableACME = true;
              acmeRoot = null;

              locations = {
                "/" = {
                  proxyPass = "http://localhost:${toString config.services.immich.port}";
                  proxyWebsockets = true;

                  extraConfig = ''
                    proxy_pass_header Authorization;
                    client_max_body_size 10G;
                  '';
                };
              };
            };
          };

          immich = {
            enable = true;
          };
        };
      }

      lib.mkIf config.anoosa.librechat.enable {
        sops = {
          secrets = {
            "librechat" = { };
          };
        };

        services = {
          nginx.virtualHosts = {
            "${config.anoosa.librechat.subdomain}.${config.anoosa.domain}" = {
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

          mongodb = {
            enable = true;
          };

          librechat = {
            enable = true;
            environmentFile = config.sops.secrets."librechat".path;
            host = "127.0.0.1";
            port = 3080;
          };
        };
      }

      lib.mkIf config.anoosa.nextcloud.enable {
        sops = {
          secrets = {
            "nextcloud/admin/password" = {
              owner = "nextcloud";
            };
          };
        };

        services = {
          nginx.virtualHosts = {
            "${config.anoosa.nextcloud.subdomain}.${config.anoosa.domain}" = {
              forceSSL = true;
              enableACME = true;
              acmeRoot = null;
            };
          };

          nextcloud = {
            enable = true;
            package = pkgs.nextcloud32;
            hostName = "${config.anoosa.nextcloud.subdomain}.${config.anoosa.domain}";
            database.createLocally = true;
            configureRedis = true;
            maxUploadSize = "16G";
            https = true;

            settings = {
              default_phone_region = "CA";
              overwriteprotocol = "https";
            };

            config = {
              dbtype = "pgsql";
              adminuser = "admin";
              adminpassFile = "/run/secrets/nextcloud/admin/password";
            };
          };
        };
      }

      lib.mkIf config.anoosa.nitter.enable {
        sops = {
          secrets = {
            "nitter" = {
              mode = "0444";
            };
          };
        };

        services = {
          nginx.virtualHosts = {
            "${config.anoosa.nitter.subdomain}.${config.anoosa.domain}" = {
              forceSSL = true;
              enableACME = true;
              acmeRoot = null;

              locations = {
                "/" = {
                  proxyPass = "http://localhost:${toString config.services.nitter.server.port}";
                };
              };
            };
          };

          nitter = {
            enable = true;
            sessionsFile = "/run/secrets/nitter";

            server = {
              port = 59181;
              https = true;
              hostname = "${config.anoosa.nitter.subdomain}.${config.anoosa.domain}";
            };

            preferences = {
              squareAvatars = true;
              replaceTwitter = "${config.anoosa.nitter.subdomain}.${config.anoosa.domain}";
              infiniteScroll = true;
              hlsPlayback = true;
            };
          };
        };
      }

      lib.mkIf config.anoosa.paperless.enable {
        sops = {
          secrets = {
            "paperless/environment" = {
              owner = "paperless";
            };
          };
        };

        services = {
          nginx.virtualHosts = {
            "${config.anoosa.paperless.subdomain}.${config.anoosa.domain}" = {
              forceSSL = true;
              enableACME = true;
              acmeRoot = null;
              locations."/" = {
                proxyPass = "http://localhost:${toString config.services.paperless.port}";
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
              PAPERLESS_DATE_ORDER = "DMY";
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

      lib.mkIf config.anoosa.soft-serve.enable {
        services = {
          soft-serve = {
            enable = true;

            settings = {
              name = config.anoosa.domain;
              log_format = "text";
              stats.listen_addr = ":23233";

              ssh = {
                listen_addr = ":23231";
                public_url = "ssh://${config.anoosa.domain}:23231";
                max_timeout = 30;
                idle_timeout = 120;
              };

              initial_admin_keys = [
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHhK2hN/aKRr12GA6dklSQbL+jG5iQ9OuvXzprvzfGc8 anas@apollo"
              ];
            };
          };
        };
      }

      lib.mkIf config.anoosa.transmission.enable {
        sops = {
          secrets = {
            "transmission/settings.json" = {
              owner = "transmission";
            };
          };
        };

        services = {
          nginx.virtualHosts = {
            "${config.anoosa.transmission.subdomain}.${config.anoosa.domain}" = {
              forceSSL = true;
              enableACME = true;
              acmeRoot = null;
              locations = {
                "/" = {
                  proxyPass = "http://localhost:9091";
                  proxyWebsockets = true;

                  extraConfig = ''
                    proxy_pass_header Authorization;
                  '';
                };
              };
            };
          };

          transmission = {
            enable = true;
            webHome = pkgs.flood-for-transmission;
            package = pkgs.transmission_4;
            downloadDirPermissions = "770";
            credentialsFile = "/run/secrets/transmission/settings.json";

            settings = {
              umask = 007;
            };
          };
        };
      }

      lib.mkIf config.anoosa.vaultwarden.enable {
        sops = {
          secrets = {
            "vaultwarden" = {
              owner = "vaultwarden";
            };
          };
        };

        services = {
          nginx.virtualHosts = {
            "${config.anoosa.vaultwarden.subdomain}.${config.anoosa.domain}" = {
              forceSSL = true;
              enableACME = true;
              acmeRoot = null;

              locations = {
                "/" = {
                  proxyPass = "http://localhost:${toString config.services.vaultwarden.config.ROCKET_PORT}";
                  proxyWebsockets = true;
                };
              };
            };
          };

          vaultwarden = {
            enable = true;
            dbBackend = "postgresql";
            environmentFile = "/run/secrets/vaultwarden";

            config = {
              DATABASE_URL = "postgresql://vaultwarden@/vaultwarden";
              DOMAIN = "https://${config.anoosa.vaultwarden.subdomain}.${config.anoosa.domain}";
              EMAIL_CHANGE_ALLOWED = "false";
              EMAIL_EXPIRATION_TIME = "300";
              ROCKET_PORT = "29486";
              SIGNUPS_ALLOWED = "false";
              SIGNUPS_DOMAINS_WHITELIST = "asherif.xyz";
              SMTP_PORT = "587";
              SMTP_SECURITY = "starttls";
              SSO_CLIENT_CACHE_EXPIRATION = "0";
              SSO_ENABLED = "true";
              SSO_ONLY = "true";
              SSO_SCOPES="openid email profile offline_access";
            };
          };

          postgresql = {
            ensureDatabases = [ "vaultwarden" ];

            ensureUsers = [
              {
                name = "vaultwarden";
                ensureDBOwnership = true;
              }
            ];
          };
        };
      }
    ];
  };
}
