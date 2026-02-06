{
  inputs,
  self,
  pkgs,
  ...
}:
{
  flake.nixosModules.server = {
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

      secrets = {
        "librechat" = {
          owner = "librechat";
        };

        "nextcloud/admin/password" = {
          owner = "nextcloud";
        };

        "nitter" = {
          mode = "0444";
        };

        "paperless/environment" = {
          owner = "paperless";
        };

        "transmission/settings.json" = {
          owner = "transmission";
        };

        "vaultwarden" = {
          owner = "vaultwarden";
        };
      };
    };

    systemd.services."phpfpm-4get".serviceConfig = {
      ReadOnlyPaths = [ "/nix/store" ];
      ReadWritePaths = [ "/var/lib/4get" ];

      BindPaths = [
        "/var/lib/4get/icons:${pkgs."4get"}/share/4get/icons"
      ];
    };

    services = {
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

      gitea = {
        enable = true;

        settings = {
          server = {
            SSH_PORT = 222;
            PROTOCOL = "http+unix";
            ROOT_URL = "https://git.asherif.xyz";
            DOMIAIN = "git.asherif.xyz";
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

      immich = {
        enable = true;
      };

      librechat = {
        enable = true;
        enableLocalDB = true;
        credentialsFile = "/run/secrets/librechat";

        env = {
          HOST = "localhost";
          PORT = "3080";
          ALLOW_EMAIL_LOGIN = false;
          ALLOW_REGISTRATION = false;
          ALLOW_SOCIAL_LOGIN = true;
          ALLOW_SOCIAL_REGISTRATION = true;
          DEEPSEEK_API_KEY = "user_provided";
          OPENROUTER_API_KEY = "user_provided";
          DOMAIN_CLIENT = "https://chat.asherif.xyz";
          DOMAIN_SERVER = "https://chat.asherif.xyz";
          ENDPOINTS = "agents,gptPlugins,google,deepseek,custom";    
          GOOGLE_KEY = "user_provided";    
          GOOGLE_MODELS = "gemini-3-pro-preview,gemini-3-pro-image-preview,gemini-3-flash-preview";    
          OPENID_ADMIN_ROLE = "admin";    
          OPENID_ADMIN_ROLE_TOKEN_KIND = "access";    
          OPENID_AUTO_REDIRECT = true;    
          OPENID_CALLBACK_URL = "/oauth/openid/callback";    
          OPENID_GENERATE_NONCE = true;    
          OPENID_JWKS_URL_CACHE_ENABLED = true;    
          OPENID_REUSE_TOKENS = true;
          OPENID_SCOPE = "openid profile email offline_access";
          OPENID_USE_END_SESSION_ENDPOINT = true;
          SEARXNG_INSTANCE_URL = "https://search.asherif.xyz";
        };

        settings = {
          version = "1.0.8";

          webSearch = {
            searchProvider = "searxng";
          };

          memory = {
            disabled = false;
            personalize = true;
            tokenLimit = 32000;
            messageWindowSize = 5;

            agent = {
              provider = "Google";
              model = "gemini-3-flash-preview";
            };
          };

          mcpServers = {
            nixos = {
              command = "${pkgs.mcp-nixos}/bin/mcp-nixos";
              args = [
                "-t"
                "stdio"
              ];
            };

            gitea = {
              command = "${pkgs.gitea-mcp-server}/bin/gitea-mcp";

              args = [
                "-t"
                "stdio"
                "--host"
                "https://git.asherif.xyz"
                "--token"
                "caf6a3dacae1e3ce2688471d9e4f7d7b6cd6a820"
              ];
            };
          };

          endpoints = {
            custom = [
              {
                name = "OpenRouter";
                apiKey = "\${OPENROUTER_API_KEY}";
                baseURL = "https://openrouter.ai/api/v1";
                titleConvo = true;
                titleModel = "moonshotai/kimi-k2.5";
                modelDisplayLabel = "OpenRouter";

                models = {
                  default = [
                    "moonshotai/kimi-k2.5"
                    "deepseek/deepseek-v3.2"
                  ];
                  fetch = true;
                };
              }
              {
                name = "Deepseek";
                apiKey = "\${DEEPSEEK_API_KEY}";
                baseURL = "https://api.deepseek.com/v1";
                titleConvo = true;
                titleModel = "deepseek-chat";
                modelDisplayLabel = "Deepseek";

                models = {
                  fetch = true;

                  default = [
                    "deepseek-chat"
                    "deepseek-reasoner"
                  ];
                };
              }
            ];
          };
        };
      };

      mongodb-ce = {
        enable = true;
      };

      nextcloud = {
        enable = true;
        package = pkgs.nextcloud32;
        hostName = "hub.asherif.xyz";
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

      nginx.virtualHosts = {
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

        "code.asherif.xyz" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          locations."/" = {
            proxyPass = "http://unix:/run/code-server/code-server.sock:/";
            proxyWebsockets = true;
            extraConfig = "proxy_pass_header Authorization;";
          };
        };

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

        "git.asherif.xyz" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;

          locations = {
            "/" = {
              proxyPass = "http://unix:/run/gitea/gitea.sock:/";
            };
          };
        };

        "home.asherif.xyz" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          locations."/" = {
            proxyPass = "http://localhost:8123";
            proxyWebsockets = true;
          };

          extraConfig = ''
            proxy_buffering off;
          '';
        };

        "hub.asherif.xyz" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
        };

        "passwords.asherif.xyz" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;

          locations = {
            "/" = {
              proxyPass = "http://localhost:8222";
              proxyWebsockets = true;
            };
          };
        };

        "photos.asherif.xyz" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;

          locations = {
            "/" = {
              proxyPass = "http://localhost:2283";
              proxyWebsockets = true;

              extraConfig = ''
                proxy_pass_header Authorization;
                client_max_body_size 10G;
              '';
            };
          };
        };

        "search.asherif.xyz" = {
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
                
                fastcgi_pass unix:/run/phpfpm/4get.sock;
                fastcgi_index index.php;
                fastcgi_buffer_size 128k;
                fastcgi_buffers 4 256k;
                fastcgi_busy_buffers_size 256k;
                include ${pkgs.nginx}/conf/fastcgi_params;
              '';
            };
          };
        };

        "torrent.asherif.xyz" = {
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

        "x.asherif.xyz" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;

          locations = {
            "/" = {
              proxyPass = "http://localhost:59181";
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
          hostname = "x.asherif.xyz";
        };

        preferences = {
          squareAvatars = true;
          replaceTwitter = "x.asherif.xyz";
          infiniteScroll = true;
          hlsPlayback = true;
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

      postgresql = {
        ensureDatabases = [
          "hass"
          "vaultwarden"
        ];

        ensureUsers = [
          {
            name = "hass";
            ensureDBOwnership = true;
          }

          {
            name = "vaultwarden";
            ensureDBOwnership = true;
          }
        ];
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

      vaultwarden = {
        enable = true;
        dbBackend = "postgresql";
        environmentFile = "/run/secrets/vaultwarden";

        config = {
          DATABASE_URL = "postgresql://vaultwarden@/vaultwarden";
          DOMAIN = "https://passwords.asherif.xyz";
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
    };

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
  };
}
