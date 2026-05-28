{
  inputs,
  self,
  ...
}:
{
  flake.nixosModules.server = { pkgs, lib, ... }: {
    imports = [
      inputs.sops-nix.nixosModules.sops
      inputs.hermes-agent.nixosModules.default
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

        "hermes" = {
          owner = "hermes";
        };

        "hindsight" = {
          owner = "hindsight";
        };
      };
    };

    ## Hindsight — agent memory server
    environment.systemPackages = [ self.packages.${pkgs.stdenv.hostPlatform.system}.hindsight ];

    systemd.services.hindsight-api = {
      description = "Hindsight API server — agent memory service";
      after = [ "network.target" "postgresql.service" ];
      wants = [ "postgresql.service" ];
      wantedBy = [ "multi-user.target" ];
      environment = {
        HINDSIGHT_API_HOST = "127.0.0.1";
        HINDSIGHT_API_PORT = "8888";
        HINDSIGHT_API_LLM_PROVIDER = "deepseek";
        HINDSIGHT_API_LLM_MODEL = "deepseek-v4-flash";
        HINDSIGHT_API_DATABASE_URL = "postgresql:///hindsight";
        HINDSIGHT_API_EMBEDDINGS_PROVIDER = "google";
        HINDSIGHT_API_RERANKER_PROVIDER = "rrf";
        HINDSIGHT_ENABLE_API = "true";
        HINDSIGHT_ENABLE_CP = "false";
        TOKENIZERS_PARALLELISM = "false";
      };
      serviceConfig = {
        ExecStart = "${self.packages.${pkgs.stdenv.hostPlatform.system}.hindsight}/bin/hindsight-api";
        User = "hindsight";
        Group = "hindsight";
        Restart = "on-failure";
        RestartSec = "5s";
        StateDirectory = "hindsight";
        WorkingDirectory = "/var/lib/hindsight";
        ReadWritePaths = [ "/var/lib/hindsight" ];
        EnvironmentFile = "/run/secrets/hindsight";
        # No network access needed beyond localhost for DB
        PrivateTmp = true;
        ProtectSystem = "strict";
        ProtectHome = true;
      };
    };

    systemd.services.hindsight-worker = {
      description = "Hindsight background worker — task processing";
      after = [ "network.target" "postgresql.service" "hindsight-api.service" ];
      wants = [ "postgresql.service" ];
      wantedBy = [ "multi-user.target" ];
      environment = {
        HINDSIGHT_API_LLM_PROVIDER = "deepseek";
        HINDSIGHT_API_LLM_MODEL = "deepseek-v4-flash";
        HINDSIGHT_API_DATABASE_URL = "postgresql:///hindsight";
        HINDSIGHT_API_EMBEDDINGS_PROVIDER = "google";
        HINDSIGHT_API_RERANKER_PROVIDER = "rrf";
        TOKENIZERS_PARALLELISM = "false";
      };
      serviceConfig = {
        ExecStart = "${self.packages.${pkgs.stdenv.hostPlatform.system}.hindsight}/bin/hindsight-worker";
        User = "hindsight";
        Group = "hindsight";
        Restart = "on-failure";
        RestartSec = "10s";
        StateDirectory = "hindsight";
        WorkingDirectory = "/var/lib/hindsight";
        ReadWritePaths = [ "/var/lib/hindsight" ];
        EnvironmentFile = "/run/secrets/hindsight";
        PrivateTmp = true;
        ProtectSystem = "strict";
        ProtectHome = true;
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
      hermes-agent = {
        enable = true;
        environmentFiles = [ "/run/secrets/hermes" ];
        addToSystemPackages = true;
        extraDependencyGroups = [ "messaging" ];

        extraPlugins = [ inputs.soosa.packages.${pkgs.stdenv.hostPlatform.system}.soosa ];
        extraPythonPackages = [
          inputs.soosa.packages.${pkgs.stdenv.hostPlatform.system}.soosa
          self.packages.${pkgs.stdenv.hostPlatform.system}.hindsight-client
        ];

        environment = {
          HASS_URL = "https://home.asherif.xyz";
          DISCORD_ALLOW_ANY_ATTACHMENT = "true";
          DISCORD_ALLOWED_USERS = "404099093435121667";
          DISCORD_ALLOWED_ROLES = "ai";
          DISCORD_ALLOW_MENTION_EVERYONE = "true";
          DISCORD_ALLOW_MENTION_ROLES = "true";
          DISCORD_FREE_RESPONSE_CHANNELS = "1217976674516471878";
          DISCORD_HOME_CHANNEL = "1217976674516471878";
          DISCORD_REQUIRE_MENTION = "true";
          DISCORD_AUTO_THREAD = "false";
          DISCORD_REACTIONS = "false";
          WHATSAPP_ENABLED = "true";
          WHATSAPP_MODE = "self-chat";
          WHATSAPP_REPLY_PREFIX = "'*Anoosa*\n────────────\n'";
          HINDSIGHT_API_URL = "http://localhost:8888";
          SOOSA_GUILD_ID = "1042512696253358100";
          SOOSA_LOG_CHANNEL_ID = "1217976674516471878";
          SOOSA_WORDLE_SUMMARY_CHANNEL = "1217975356070297620";
        };

        extraPackages = [ pkgs.libopus ];

        #container = {
        #  enable = true;
        #  backend = "podman";
        #  hostUsers = [ "anas" ];
        #};

        settings = {
          plugins = {
            enabled = [ "soosa" ];
          };

          toolsets = [ "all" ];

          model = {
            provider = "deepseek";
            default = "deepseek-v4-flash";
          };

          terminal = {
            backend = "local";
            timeout = 180;
            cwd = "/var/lib/hermes/workspace";
          };

          display = {
            compact = false;
            personality = "kawaii";
          };

          whatsapp = {
            unauthorized_dm_behavior = "ignore";
          };

          mcp_servers = {
	    nix = {
	      command = "/run/current-system/sw/bin/nix";
	      args = [ "run" "github:utensils/mcp-nixos" "--" ];
	    };
	  };

          memory = {
            memory_enabled = true;
            user_profile_enabled = true;
            provider = "hindsight";
          };
        };
      };

      #code-server = {
      #  enable = true;
      #  auth = "none";
      #  disableGettingStartedOverride = true;
      #  disableTelemetry = true;
      #  disableUpdateCheck = true;
      #  disableWorkspaceTrust = true;
      #  proxyDomain = "code.asherif.xyz";
      #  socket = "/run/code-server/code-server.sock";
      #  socketMode = "777";
      #  user = "anas";
      #  group = "anas";

      #  package = pkgs.vscode-with-extensions.override {
      #    vscode = pkgs.code-server;
      #    vscodeExtensions = with pkgs.vscode-extensions; [
      #      Google.gemini-cli-vscode-ide-companion
      #      asvetliakov.vscode-neovim
      #      bbenoist.nix
      #      catppuccin.catppuccin-vsc
      #      catppuccin.catppuccin-vsc-icons
      #    ];
      #  };

      #  extraPackages = [
      #    pkgs.gemini-cli
      #  ];
      #};

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

        extraApps = {
          prayertimes = self.packages.${pkgs.stdenv.hostPlatform.system}.prayertimes;
        };

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

          "anoosa.asherif.xyz" = {
            forceSSL = true;
            enableACME = true;
            acmeRoot = null;

            locations."/" = {
              proxyPass = "http://localhost:9119";
              proxyWebsockets = true;
              extraConfig = "proxy_set_header Host $host;";
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
              client_max_body_size 0;
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

          "sunshine.asherif.xyz" = {
            forceSSL = true;
            enableACME = true;
            acmeRoot = null;

            locations = {
              "/" = {
                proxyPass = "http://localhost:47990";
              };
            };
          };

          "tty.asherif.xyz" = {
            forceSSL = true;
            enableACME = true;
            acmeRoot = null;

            locations = {
              "/" = {
                proxyPass = "http://localhost:7681";
                proxyWebsockets = true;
                extraConfig = ''
                  # Inject font + hide scrollbar via sub_filter
                  sub_filter_types text/html;
                  sub_filter '</head>' '<style>@font-face { font-family: "Comic Code Ligatures"; src: url(/static/fonts/ComicCodeLigatures.otf) format("opentype"); } .xterm .xterm-viewport::-webkit-scrollbar { width: 0 !important; height: 0 !important; display: none !important; } .xterm .xterm-viewport { scrollbar-width: none !important; -ms-overflow-style: none !important; overflow-y: hidden !important; }</style></head>';
                  sub_filter_once on;
                '';
              };

              "= /static/fonts/ComicCodeLigatures.otf" = {
                alias = "${pkgs.runCommand "comic-code-font" { } ''ln -s "${self.packages.${pkgs.stdenv.hostPlatform.system}.comic-code}/share/fonts/opentype/Comic Code Ligatures.otf" "$out"''}";
                extraConfig = ''
                  add_header Cache-Control "public, max-age=31536000, immutable";
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

          "memory.asherif.xyz" = {
            forceSSL = true;
            enableACME = true;
            acmeRoot = null;

            locations."/" = {
              proxyPass = "http://localhost:8888";
              proxyWebsockets = true;
              extraConfig = ''
                proxy_set_header Host $host;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Proto $scheme;
              '';
            };
          };
        };

        tailscaleAuth = {
          enable = true;
          virtualHosts = [ "tty.asherif.xyz" ];
          expectedTailnet = "dragon-armadillo.ts.net";
        };
      };

      ttyd = {
        enable = true;
        interface = "127.0.0.1";
        user = "anas";
        writeable = true;
        maxClients = 3;
        entrypoint = [ "${self.packages.${pkgs.stdenv.hostPlatform.system}.tmux}/bin/tmux" "new" "-As0" "-c" "/home/anas" ];

        clientOptions = {
          fontFamily = "\"Comic Code Ligatures\", monospace";
          fontSize = "16";
          scrollback = "0";
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

      phpfpm.pools."4get" = {
        user = "nginx";
        group = "nginx";

        phpPackage = pkgs.php83.withExtensions (
          { all, ... }:
          with all;
          [
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
          ]
        );

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
        enable = true;
        enableJIT = false;
        package = pkgs.postgresql_16;
        extraPlugins = with pkgs.postgresql16Packages; [ pgvector ];

        ensureDatabases = [
          "hass"
          "hindsight"
        ];

        ensureUsers = [
          {
            name = "hass";
            ensureDBOwnership = true;
          }
          {
            name = "hindsight";
            ensureDBOwnership = true;
          }
        ];


        settings = {
          shared_preload_libraries = "vector";
        };
      };
    };

    users.users.hindsight = {
      isSystemUser = true;
      group = "hindsight";
      home = "/var/lib/hindsight";
      createHome = true;
    };

    users.groups.hindsight = {};

    #users = {
    #  users = {
    #    code-server = {
    #      homeMode = "700";

    #      openssh.authorizedKeys.keys = [
    #        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHhK2hN/aKRr12GA6dklSQbL+jG5iQ9OuvXzprvzfGc8 anas@apollo"
    #      ];
    #    };
    #  };
    #};
  };
}
