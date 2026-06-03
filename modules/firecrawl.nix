{
  inputs,
  self,
  ...
}: {
  flake.nixosModules.firecrawl = { pkgs, lib, config, ... }:
    let
      cfg = config.services.firecrawl;
    in {
      options.services.firecrawl = {
        enable = lib.mkEnableOption "Firecrawl web scraping API";

        apiPort = lib.mkOption {
          type = lib.types.port;
          default = 3002;
          description = "Port for the firecrawl API server";
        };

        playwrightPort = lib.mkOption {
          type = lib.types.port;
          default = 3000;
          description = "Port for the Playwright browser service";
        };

        environment = lib.mkOption {
          type = lib.types.attrsOf lib.types.str;
          default = { };
          description = "Extra environment variables passed to the firecrawl container";
        };

        environmentFiles = lib.mkOption {
          type = lib.types.listOf lib.types.path;
          default = [ ];
          description = "Environment files to pass to the firecrawl container (e.g. sops secrets)";
        };

        enableRabbitMQ = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Whether to enable RabbitMQ (needed for NUQ job queue)";
        };

        nginx = lib.mkOption {
          type = lib.types.nullOr (lib.types.submodule {
            options = {
              hostName = lib.mkOption {
                type = lib.types.str;
                description = "Hostname for the nginx virtual host";
              };
              enableACME = lib.mkOption {
                type = lib.types.bool;
                default = true;
                description = "Whether to enable ACME for automatic SSL";
              };
            };
          });
          default = null;
          description = "Optional nginx reverse proxy configuration";
        };
      };

      config = lib.mkIf cfg.enable {
        # ── Redis ──────────────────────────────────────────────────────
        services.redis = {
          enable = true;
          bind = "127.0.0.1";
          port = 6379;
          settings = {
            save = [ "" ];
            appendonly = "yes";
          };
        };

        # ── RabbitMQ (optional) ────────────────────────────────────────
        services.rabbitmq = lib.mkIf cfg.enableRabbitMQ {
          enable = true;
          bind = "127.0.0.1";
          port = 5672;
          managementPlugin.enable = true;
        };

        # ── Podman ─────────────────────────────────────────────────────
        virtualisation.podman = {
          enable = true;
          defaultNetwork.settings.dns_enabled = true;
        };

        # ── OCI containers ─────────────────────────────────────────────
        virtualisation.oci-containers = {
          backend = "podman";

          containers = {
            # Browser-based scraping via Playwright
            firecrawl-playwright = {
              image = "ghcr.io/firecrawl/playwright-service:latest";
              autoStart = true;
              environment = {
                PORT = toString cfg.playwrightPort;
              } // lib.optionalAttrs (cfg.environment ? PROXY_SERVER) {
                PROXY_SERVER = cfg.environment.PROXY_SERVER;
                PROXY_USERNAME = cfg.environment.PROXY_USERNAME or "";
                PROXY_PASSWORD = cfg.environment.PROXY_PASSWORD or "";
              };
              extraOptions = [
                "--network=host"
                "--tmpfs" "/tmp/.cache:noexec,nosuid,size=1g"
                "--memory" "4g"
                "--cpus" "2"
              ];
            };

            # Main firecrawl API server
            firecrawl-api = {
              image = "ghcr.io/firecrawl/firecrawl:v2.10";
              autoStart = true;
              environmentFiles = cfg.environmentFiles;
              environment =
                {
                  PORT = toString cfg.apiPort;
                  HOST = "0.0.0.0";
                  REDIS_URL = "redis://127.0.0.1:6379";
                  REDIS_RATE_LIMIT_URL = "redis://127.0.0.1:6379";
                  PLAYWRIGHT_MICROSERVICE_URL =
                    "http://127.0.0.1:${toString cfg.playwrightPort}/scrape";
                  BULL_AUTH_KEY = "changeme";
                  USE_DB_AUTHENTICATION = "false";
                }
                // lib.optionalAttrs cfg.enableRabbitMQ {
                  NUQ_RABBITMQ_URL = "amqp://127.0.0.1:5672";
                }
                // cfg.environment;
              extraOptions = [
                "--network=host"
                "--memory" "8g"
                "--cpus" "4"
              ];
            };
          };
        };

        # ── Service ordering ───────────────────────────────────────────
        systemd.services."container-firecrawl-api" = {
          after = [
            "container-firecrawl-playwright.service"
            "redis.service"
          ] ++ lib.optional cfg.enableRabbitMQ "rabbitmq.service";
          requires = [
            "container-firecrawl-playwright.service"
            "redis.service"
          ] ++ lib.optional cfg.enableRabbitMQ "rabbitmq.service";
        };

        # ── Nginx reverse proxy ────────────────────────────────────────
        services.nginx = lib.mkIf (cfg.nginx != null) {
          virtualHosts.${cfg.nginx.hostName} = {
            forceSSL = true;
            enableACME = cfg.nginx.enableACME;
            acmeRoot = null;

            locations."/" = {
              proxyPass = "http://127.0.0.1:${toString cfg.apiPort}";
              proxyWebsockets = true;
              extraConfig = ''
                proxy_set_header Host $host;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Proto $scheme;
                proxy_buffering off;
              '';
            };
          };
        };
      };
    };
}
