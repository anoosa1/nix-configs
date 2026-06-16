{
  inputs,
  self,
  ...
}:
{
  flake.nixosModules.server = { pkgs, lib, config, ... }: {
    imports = [
      inputs.sops-nix.nixosModules.sops
      inputs.hermes-agent.nixosModules.default
      self.nixosModules.ai
      self.nixosModules.media
      self.nixosModules.security
      #self.nixosModules.vpn
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

        "searxng" = {
          owner = "searx";
        };

        "nextcloud/oidc" = {
          owner = "nextcloud";
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
        home = "/data/lib/nextcloud";
        hostName = "hub.asherif.xyz";
        https = true;
        maxUploadSize = "16G";
        package = pkgs.nextcloud33;
        extraApps = {
          inherit (config.services.nextcloud.package.packages.apps)
            calendar contacts notes tasks news music cookbook;
          user_oidc = pkgs.fetchNextcloudApp {
            url = "https://github.com/nextcloud-releases/user_oidc/releases/download/v8.10.1/user_oidc-v8.10.1.tar.gz";
            hash = "sha256-Sc7R/hkjAvRUC4aUOLbMucoNabcXt27XB1pwqlz2Zv0=";
            license = "agpl3Only";
          };
        };
        extraAppsEnable = true;

        #extraApps = {
        #  prayertimes = self.packages.${pkgs.stdenv.hostPlatform.system}.prayertimes;
        #};

        settings = {
          allow_local_remote_servers = true;
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

            extraConfig = ''
              proxy_buffering off;
            '';

            locations = {
              "/" = {
                proxyPass = "http://localhost:4096";
                proxyWebsockets = true;
                extraConfig = "proxy_set_header Host $host;";
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
              client_max_body_size 0;
            '';

            locations = {
              "/" = {
                proxyPass = "http://unix:/run/gitea/gitea.sock:/";
              };

              "/user/login" = {
                return = "302 /user/oauth2/authelia";
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
        extensions = with pkgs.postgresql16Packages; [ pgvector ];

        ensureDatabases = [
          "hass"
        ];

        ensureUsers = [
          {
            name = "hass";
            ensureDBOwnership = true;
          }
        ];

        settings = {
          shared_preload_libraries = "vector";
        };
      };

      nginx.virtualHosts."searxng.asherif.xyz" = {
        forceSSL = true;
        enableACME = true;
        acmeRoot = null;
      };

      searx = {
        enable = true;
        domain = "searxng.asherif.xyz";
        configureNginx = true;
        redisCreateLocally = true;
        environmentFile = "/run/secrets/searxng";

        settings = {
          server = {
            secret_key = "$SECRET_KEY";
            bind_address = "127.0.0.1";
            port = 8880;
          };

          search = {
            safe_search = 0;
            autocomplete = "google";
            languages = [ "en" "fr" "ar" ];
            formats = [ "html" "json" "rss" "csv" ];
          };

          ui = {
            static_use_hash = true;
          };

          outgoing = {
            request_timeout = 5.0;
            max_request_timeout = 10.0;
            useragent_suffix = "";
          };

          default_doi_resolver = "sci-hub.st";

          #plugins = {
          #  searx.plugins.oa_doi_rewrite.SXNGPlugin = {
          #    active = true;
          #  };
          #  searx.plugins.infinite_scroll.SXNGPlugin = {
          #    active = true;
          #  };
          #};

          engines = [
            # General
            {
              name = "google";
              disabled = false;
            }
            {
              name = "duckduckgo";
              disabled = false;
            }

            # Images
            {
              name = "google images";
              categories = [ "images" ];
            }
            {
              name = "bing images";
              categories = [ "images" ];
            }
            {
              name = "unsplash";
              categories = [ "images" ];
            }
            {
              name = "wikicommons.images";
            }
            {
              name = "public domain image archive";
              disabled = false;
              categories = [ "images" ];
            }

            # Videos
            {
              name = "youtube";
              categories = [ "videos" "music" ];
            }
            {
              name = "google videos";
              categories = [ "videos" ];
            }
            {
              name = "wikicommons.videos";
            }

            # News
            {
              name = "brave.news";
            }
            {
              name = "wikinews";
            }

            # Map
            {
              name = "apple maps";
              disabled = false;
              categories = [ "map" ];
            }
            {
              name = "openstreetmap";
              categories = [ "map" ];
            }
            {
              name = "photon";
              categories = [ "map" ];
            }

            # Music
            {
              name = "bandcamp";
            }
            {
              name = "wikicommons.audio";
            }

            # IT
            {
              name = "stackoverflow";
            }
            {
              name = "askubuntu";
            }
            {
              name = "github";
              categories = [ "it" ];
            }
            {
              name = "arch linux wiki";
              categories = [ "it" ];
            }
            {
              name = "nixos wiki";
              disabled = false;
            }
            {
              name = "gentoo";
            }
            {
              name = "hackernews";
              disabled = false;
              categories = [ "it" ];
            }

            # Science
            {
              name = "arxiv";
              categories = [ "science" ];
            }
            {
              name = "google scholar";
              categories = [ "science" ];
            }
            {
              name = "pubmed";
              categories = [ "science" ];
            }

            # Files
            {
              name = "1337x";
              disabled = false;
              categories = [ "files" ];
            }
            {
              name = "wikicommons.files";
            }
            {
              name = "nyaa";
              disabled = false;
              categories = [ "files" ];
            }
            {
              name = "bt4g";
              categories = [ "files" ];
            }
            {
              name = "annas archive";
              disabled = false;
              categories = [ "files" ];
            }

            # Social media
            {
              name = "reddit";
              disabled = false;
              categories = [ "social media" ];
            }
            {
              name = "pinterest";
              categories = [ "social media" ];
            }
            {
              name = "lemmy communities";
              categories = [ "social media" ];
            }
            {
              name = "lemmy posts";
              categories = [ "social media" ];
            }
            {
              name = "lemmy users";
              categories = [ "social media" ];
            }
            {
              name = "lemmy comments";
              categories = [ "social media" ];
            }
            {
              name = "mastodon users";
              categories = [ "social media" ];
            }
            {
              name = "mastodon hashtags";
              categories = [ "social media" ];
            }

            # Other
            {
              name = "wttr.in";
            }
            {
              name = "steam";
              disabled = false;
            }
            {
              name = "etymonline";
            }
            {
              name = "wiktionary";
            }
            {
              name = "wordnik";
            }
          ];
        };
      };

    };
    systemd.services.nextcloud-configure-oidc = {
      description = "Configure Authelia OIDC provider in Nextcloud";
      requires = [ "nextcloud-setup.service" ];
      after = [ "nextcloud-setup.service" "nextcloud.service" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "oneshot";
        User = "nextcloud";
        Group = "nextcloud";
        RemainAfterExit = true;
      };

      script = ''
        if [ ! -f /run/secrets/nextcloud/oidc ]; then
          echo "OIDC secret not found at /run/secrets/nextcloud/oidc — skipping provider setup"
          exit 0
        fi

        ${config.services.nextcloud.occ}/bin/nextcloud-occ user_oidc:provider Authelia \
          --clientid="nextcloud" \
          --clientsecret-file="/run/secrets/nextcloud/oidc" \
          --discoveryuri="https://auth.asherif.xyz/.well-known/openid-configuration" \
          --scope="openid profile email" \
          --endsessionendpointuri="https://auth.asherif.xyz/logout" \
          --mapping-uid="preferred_username" \
          --mapping-display-name="name" \
          --mapping-email="email" \
          --mapping-groups="groups" \
          --group-provisioning="1" \
          --unique-uid="0" \
          || true

        ${config.services.nextcloud.occ}/bin/nextcloud-occ app:enable files_external || true
      '';
    };
  };
}
