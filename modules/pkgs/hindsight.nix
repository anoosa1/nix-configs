# modules/pkgs/hindsight.nix
# Nix package for the Hindsight agent memory server.
{
  perSystem = { pkgs, lib, ... }:
    let
      python3 = pkgs.python3;
      python3Packages = pkgs.python3Packages.override {
        overrides = self: super: {
          obstore = super.obstore.overridePythonAttrs (old: {
            doCheck = false;
          });
        };
      };
    in
    {
      packages.hindsight = python3Packages.buildPythonApplication {
        pname = "hindsight";
        version = "0.6.2";

        src = pkgs.fetchzip {
          name = "hindsight-source";
          url = "https://github.com/vectorize-io/hindsight/archive/refs/heads/main.tar.gz";
          hash = "sha256-RTxROxeLkVdmcVQ5UCYSe+SIqKkEeHrYkL9dLnJ3TPY=";
        };

        dontUnpack = true;

        preBuild = ''
          cp -r "$src"/hindsight-api-slim/. ./
          cp -r "$src"/hindsight-clients/python/. ./clients/
          sed -i '/^dependencies = \[/,/^\]/c\dependencies = []' pyproject.toml
          sed -i '/^\[project.optional-dependencies\]/,/^\[/c\# removed' pyproject.toml
        '';

        format = "pyproject";

        nativeBuildInputs = with python3Packages; [
          hatchling
          python-dateutil
          pkgs.makeWrapper
        ];

        propagatedBuildInputs = with python3Packages; [
          fastapi uvicorn pydantic wsproto
          sqlalchemy alembic asyncpg psycopg2-binary pgvector greenlet
          openai anthropic google-genai google-auth cohere litellm claude-agent-sdk
          tiktoken langchain-text-splitters
          python-dotenv typer rich dateparser python-dateutil
          httpx boto3 markitdown obstore python-multipart
          pyjwt authlib cryptography filelock pyasn1 urllib3
          opentelemetry-api opentelemetry-sdk
          opentelemetry-instrumentation-fastapi
          opentelemetry-exporter-prometheus opentelemetry-exporter-otlp-proto-http
          opentelemetry-semantic-conventions
          langchain-core langsmith orjson protobuf pillow tornado aiohttp
          pygments fastmcp uvloop
        ];

        pipInstallFlags = ["--no-deps"];

        postInstall = ''
          # Install the server API
          mkdir -p $out/bin
          for ep in hindsight-api hindsight-worker hindsight-local-mcp hindsight-admin; do
            makeWrapper "${python3.interpreter}" "$out/bin/$ep" \
              --add-flags "-m $(
                case $ep in
                  hindsight-api) echo hindsight_api.main ;;
                  hindsight-worker) echo hindsight_api.worker.main ;;
                  hindsight-local-mcp) echo hindsight_api.mcp_local ;;
                  hindsight-admin) echo hindsight_api.admin.cli ;;
                esac
              )" \
              --set PYTHONPATH "$out/lib/${python3.libPrefix}/site-packages:$PYTHONPATH"
          done
          # Install the Python client library into site-packages
          cp -r ./clients/hindsight_client $out/lib/${python3.libPrefix}/site-packages/
          cp -r ./clients/hindsight_client_api $out/lib/${python3.libPrefix}/site-packages/
        '';

        meta = with lib; {
          description = "Agent memory that works like human memory — self-hosted server";
          homepage = "https://hindsight.vectorize.io";
          license = licenses.mit;
          platforms = platforms.linux;
          mainProgram = "hindsight-api";
          maintainers = [];
        };
      };
    };
}
