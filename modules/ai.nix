{ inputs, self, ... }: {
  flake.nixosModules.ai = { pkgs, config, ... }: {
    imports = [
      self.nixosModules.hindsight
    ];

    services.hindsight = {
      enable = true;
      environmentFile = "/run/secrets/hindsight";

      api = {
        host = "127.0.0.1";
        port = 8888;
        llmProvider = "deepseek";
        llmModel = "deepseek-v4-flash";
        embeddingsProvider = "google";
        rerankerProvider = "rrf";
        enableApi = true;
        enableCp = false;
      };

      database.url = "postgresql:///hindsight";
    };

    sops.secrets."open-webui" = {
      owner = "root";
      mode = "0444";
    };

    sops.secrets."hermes" = {
      owner = "hermes";
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
          ENABLE_OLLAMA_API = "false";
          ENABLE_PASSWORD_AUTH = "false";
          ENABLE_PASSWORD_CHANGE_FORM = "false";
          OAUTH_ADMIN_ROLES = "admin";
          OAUTH_CLIENT_ID = "open-webui";
          OAUTH_CODE_CHALLENGE_METHOD = "S256";
          OAUTH_MERGE_ACCOUNTS_BY_EMAIL = "true";
          OAUTH_PROVIDER_NAME = "Authelia";
          OAUTH_ROLES_CLAIM = "groups";
          OAUTH_SCOPES = "openid profile email groups";
          OAUTH_USERNAME_CLAIM = "preferred_username";
          OPENAI_API_BASE_URL = "http://127.0.0.1:8642/v1";
          OPENID_PROVIDER_URL = "https://auth.asherif.xyz/.well-known/openid-configuration";
          WEBUI_NAME = "Soosa";
          WEBUI_URL = "https://chat.asherif.xyz";

          # DeepSeek as default LLM
          OPENAI_API_BASE_URL = "https://api.deepseek.com";

          # Hindsight for RAG/embeddings (runs on localhost:8888)
          RAG_OPENAI_API_BASE_URL = "http://127.0.0.1:8888/v1";
        };
      };

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
          DISCORD_ALLOW_ALL_USERS = "true";
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
          API_SERVER_ENABLED = "true";
        };

        extraPackages = [ pkgs.libopus ];

        #container = {
        #  enable = true;
        #  backend = "podman";
        #  hostUsers = [ "anas" ];
        #};

        settings = {
          group_sessions_per_user = false;

          plugins = {
            enabled = [ "soosa" ];
          };

          discord = {
            history_backfill_limit = 50;
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

      nginx = {
        virtualHosts = {
          "chat.asherif.xyz" = {
            forceSSL = true;
            enableACME = true;
            acmeRoot = null;

            locations."/" = {
              proxyPass = "http://127.0.0.1:3080";
              proxyWebsockets = true;
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
