{ inputs, self, ... }: {
  flake.nixosModules.hindsight = { pkgs, lib, config, ... }:
    let
      cfg = config.services.hindsight;
      inherit (lib) mkOption types mkIf literalExpression;
    in
    {
      options.services.hindsight = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = "Whether to enable Hindsight agent memory server.";
        };

        package = mkOption {
          type = types.package;
          default = self.packages.${pkgs.stdenv.hostPlatform.system}.hindsight;
          defaultText = literalExpression "self.packages.\\${pkgs.stdenv.hostPlatform.system}.hindsight";
          description = "The hindsight package to use.";
        };

        environmentFile = mkOption {
          type = types.str;
          default = "/run/secrets/hindsight";
          description = "Path to environment file with API keys.";
        };

        domain = mkOption {
          type = types.str;
          default = "memory.asherif.xyz";
          description = "Domain for the hindsight nginx virtual host.";
        };

        api = {
          host = mkOption {
            type = types.str;
            default = "127.0.0.1";
            description = "Host address for the hindsight API server.";
          };

          port = mkOption {
            type = types.port;
            default = 8888;
            description = "Port for the hindsight API server.";
          };

          llmProvider = mkOption {
            type = types.str;
            default = "deepseek";
            description = "LLM provider for hindsight.";
          };

          llmModel = mkOption {
            type = types.str;
            default = "deepseek-v4-flash";
            description = "LLM model for hindsight.";
          };

          embeddingsProvider = mkOption {
            type = types.str;
            default = "google";
            description = "Embeddings provider for hindsight.";
          };

          rerankerProvider = mkOption {
            type = types.str;
            default = "rrf";
            description = "Reranker provider for hindsight.";
          };

          enableApi = mkOption {
            type = types.bool;
            default = true;
            description = "Whether to enable the hindsight API.";
          };

          enableCp = mkOption {
            type = types.bool;
            default = false;
            description = "Whether to enable hindsight control plane.";
          };
        };

        database.url = mkOption {
          type = types.str;
          default = "postgresql:///hindsight";
          description = "Database URL for hindsight.";
        };
      };

      config = mkIf cfg.enable {
        sops.secrets."hindsight" = {
          owner = "hindsight";
        };

        environment.systemPackages = [ cfg.package ];

        systemd.services.hindsight-api = {
          description = "Hindsight API server — agent memory service";
          after = [ "network.target" "postgresql.service" ];
          wants = [ "postgresql.service" ];
          wantedBy = [ "multi-user.target" ];
          environment = {
            HINDSIGHT_API_HOST = cfg.api.host;
            HINDSIGHT_API_PORT = toString cfg.api.port;
            HINDSIGHT_API_LLM_PROVIDER = cfg.api.llmProvider;
            HINDSIGHT_API_LLM_MODEL = cfg.api.llmModel;
            HINDSIGHT_API_DATABASE_URL = cfg.database.url;
            HINDSIGHT_API_EMBEDDINGS_PROVIDER = cfg.api.embeddingsProvider;
            HINDSIGHT_API_RERANKER_PROVIDER = cfg.api.rerankerProvider;
            HINDSIGHT_ENABLE_API = if cfg.api.enableApi then "true" else "false";
            HINDSIGHT_ENABLE_CP = if cfg.api.enableCp then "true" else "false";
            TOKENIZERS_PARALLELISM = "false";
          };
          serviceConfig = {
            ExecStart = "${cfg.package}/bin/hindsight-api";
            User = "hindsight";
            Group = "hindsight";
            Restart = "on-failure";
            RestartSec = "5s";
            StateDirectory = "hindsight";
            WorkingDirectory = "/var/lib/hindsight";
            ReadWritePaths = [ "/var/lib/hindsight" ];
            EnvironmentFile = cfg.environmentFile;
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
            HINDSIGHT_API_LLM_PROVIDER = cfg.api.llmProvider;
            HINDSIGHT_API_LLM_MODEL = cfg.api.llmModel;
            HINDSIGHT_API_DATABASE_URL = cfg.database.url;
            HINDSIGHT_API_EMBEDDINGS_PROVIDER = cfg.api.embeddingsProvider;
            HINDSIGHT_API_RERANKER_PROVIDER = cfg.api.rerankerProvider;
            TOKENIZERS_PARALLELISM = "false";
          };
          serviceConfig = {
            ExecStart = "${cfg.package}/bin/hindsight-worker";
            User = "hindsight";
            Group = "hindsight";
            Restart = "on-failure";
            RestartSec = "10s";
            StateDirectory = "hindsight";
            WorkingDirectory = "/var/lib/hindsight";
            ReadWritePaths = [ "/var/lib/hindsight" ];
            EnvironmentFile = cfg.environmentFile;
            PrivateTmp = true;
            ProtectSystem = "strict";
            ProtectHome = true;
          };
        };

        services.nginx.virtualHosts."${cfg.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;

          locations."/" = {
            proxyPass = "http://${cfg.api.host}:${toString cfg.api.port}";
            proxyWebsockets = true;
            extraConfig = ''
              proxy_set_header Host $host;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Proto $scheme;
            '';
          };
        };

        services.postgresql = {
          ensureDatabases = [ "hindsight" ];
          ensureUsers = [
            {
              name = "hindsight";
              ensureDBOwnership = true;
            }
          ];
        };

        users.users.hindsight = {
          isSystemUser = true;
          group = "hindsight";
          home = "/var/lib/hindsight";
          createHome = true;
        };

        users.groups.hindsight = {};
      };
    };
}
