{
  inputs,
  self,
  ...
}:
{
  flake.nixosModules.server = { pkgs, ... }: {
    imports = [
      inputs.sops-nix.nixosModules.sops
      #self.nixosModules.ai
      self.nixosModules.media
      self.nixosModules.security
    ];

    ## sops
    sops = {
      defaultSopsFile = "${inputs.secrets}/secrets.yaml";
      defaultSopsFormat = "yaml";
      age = {
        keyFile = "/home/anas/.local/etc/sops/age/keys.txt";
      };

      secrets = {
        "cloudflare" = {
          owner = "acme";
        };

        "nitter" = {
          mode = "0444";
        };

        "paperless" = {
          owner = "paperless";
        };
      };
    };

    systemd.services."phpfpm-4get".serviceConfig = {
      ReadOnlyPaths = [ "/nix/store" ];
      ReadWritePaths = [ "/var/lib/4get" ];

      BindPaths = [
        "/var/lib/4get/icons:${self.packages.${pkgs.stdenv.hostPlatform.system}."4get"}/share/4get/icons"
        "/var/lib/4get/data/config.php:${self.packages.${pkgs.stdenv.hostPlatform.system}."4get"}/share/4get/data/config.php"
      ];
    };

    services = {
      code-server = {
        enable = true;
        auth = "none";
        disableGettingStartedOverride = true;
        disableTelemetry = true;
        disableUpdateCheck = true;
        disableWorkspaceTrust = true;
        proxyDomain = "code.asherif.xyz";
        socket = "/run/code-server/code-server.sock";
        socketMode = "777";
        #user = "anas";

        package = pkgs.vscode-with-extensions.override {
          vscode = pkgs.code-server;
          vscodeExtensions = with pkgs.vscode-extensions; [
            Google.gemini-cli-vscode-ide-companion
            asvetliakov.vscode-neovim
            bbenoist.nix
            catppuccin.catppuccin-vsc
            catppuccin.catppuccin-vsc-icons
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
            SSH_PORT = 22;
            PROTOCOL = "http+unix";
            ROOT_URL = "https://git.asherif.xyz";
            DOMIAIN = "git.asherif.xyz";
            LANDING_PAGE = "/anoosa";
          };

          admin = {
            EXTERNAL_USER_DISABLED_FEATURES = "manage_mfa,manage_credentials";
          };

          session = {
            COOKIE_SECURE = true;
          };

          service = {
            ALLOW_ONLY_EXTERNAL_REGISTRATION = true;
            DISABLE_REGISTRATION = true;
            ENABLE_BASIC_AUTHENTICATION = false;
            ENABLE_PASSWORD_SIGNIN_FORM = false;
            SHOW_REGISTRATION_BUTTON = false;
          };

          openid = {
            ENABLE_OPENID_SIGNIN = false;
            ENABLE_OPENID_SIGNUP = true;
            WHITELISTED_URIS = "auth.asherif.xyz";
          };

          ui = {
            DEFAULT_THEME = "catppuccin-mocha-pink";
            THEMES = "catppuccin-latte-rosewater,catppuccin-latte-flamingo,catppuccin-latte-pink,catppuccin-latte-mauve,catppuccin-latte-red,catppuccin-latte-maroon,catppuccin-latte-peach,catppuccin-latte-yellow,catppuccin-latte-green,catppuccin-latte-teal,catppuccin-latte-sky,catppuccin-latte-sapphire,catppuccin-latte-blue,catppuccin-latte-lavender,catppuccin-frappe-rosewater,catppuccin-frappe-flamingo,catppuccin-frappe-pink,catppuccin-frappe-mauve,catppuccin-frappe-red,catppuccin-frappe-maroon,catppuccin-frappe-peach,catppuccin-frappe-yellow,catppuccin-frappe-green,catppuccin-frappe-teal,catppuccin-frappe-sky,catppuccin-frappe-sapphire,catppuccin-frappe-blue,catppuccin-frappe-lavender,catppuccin-macchiato-rosewater,catppuccin-macchiato-flamingo,catppuccin-macchiato-pink,catppuccin-macchiato-mauve,catppuccin-macchiato-red,catppuccin-macchiato-maroon,catppuccin-macchiato-peach,catppuccin-macchiato-yellow,catppuccin-macchiato-green,catppuccin-macchiato-teal,catppuccin-macchiato-sky,catppuccin-macchiato-sapphire,catppuccin-macchiato-blue,catppuccin-macchiato-lavender,catppuccin-mocha-rosewater,catppuccin-mocha-flamingo,catppuccin-mocha-pink,catppuccin-mocha-mauve,catppuccin-mocha-red,catppuccin-mocha-maroon,catppuccin-mocha-peach,catppuccin-mocha-yellow,catppuccin-mocha-green,catppuccin-mocha-teal,catppuccin-mocha-sky,catppuccin-mocha-sapphire,catppuccin-mocha-blue,catppuccin-mocha-lavender";
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

      nextcloud = {
        enable = true;
        configureRedis = true;
        database.createLocally = true;
        hostName = "hub.asherif.xyz";
        https = true;
        maxUploadSize = "16G";
        package = pkgs.nextcloud33;

        settings = {
          default_phone_region = "CA";
          overwriteprotocol = "https";

          user_oidc_default = {
            token_endpoint_auth_method = "client_secret_post";
          };
        };

        config = {
          adminpassFile = null;
          adminuser = null;
          dbtype = "pgsql";
        };
      };

      nginx = {
        recommendedTlsSettings = true;
        recommendedProxySettings = true;

        virtualHosts = {
          "p1.asherif.xyz" = {
            forceSSL = true;
            enableACME = true;
            acmeRoot = null;
            locations = {
              "/" = {
                proxyPass = "https://10.0.0.10:8006";
                proxyWebsockets = true;
              };
            };
          };

          "accounts.asherif.xyz" = {
            forceSSL = true;
            enableACME = true;
            acmeRoot = null;
            locations = {
              "/" = {
                proxyPass = "https://10.0.0.2:9443";
                proxyWebsockets = true;
              };

              "~ (/authentik)?/api" = {
                proxyPass = "https://10.0.0.2:9443";
                proxyWebsockets = true;
              };
            };
          };

          "code.asherif.xyz" = {
            forceSSL = true;
            enableACME = true;
            acmeRoot = null;

            locations = {
              "/" = {
                proxyPass = "http://unix:/run/code-server/code-server.sock:/";
                proxyWebsockets = true;
              };
            };
          };

          "docs.asherif.xyz" = {
            forceSSL = true;
            enableACME = true;
            acmeRoot = null;

            extraConfig = ''
              proxy_hide_header X-Frame-Options;
              add_header Content-Security-Policy "frame-ancestors 'self' https://hub.asherif.xyz;" always;
            '';

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

            extraConfig = ''
              proxy_hide_header X-Frame-Options;
              add_header Content-Security-Policy "frame-ancestors 'self' https://hub.asherif.xyz;" always;
            '';

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
              proxy_hide_header X-Frame-Options;
              add_header Content-Security-Policy "frame-ancestors 'self' https://hub.asherif.xyz;" always;

            '';
          };

          "hub.asherif.xyz" = {
            forceSSL = true;
            enableACME = true;
            acmeRoot = null;
          };

          "search.asherif.xyz" = {
            root = "${self.packages.${pkgs.stdenv.hostPlatform.system}."4get"}/share/4get";
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
        environmentFile = "/run/secrets/paperless";

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
        ];

        ensureUsers = [
          {
            name = "hass";
            ensureDBOwnership = true;
          }
        ];
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
