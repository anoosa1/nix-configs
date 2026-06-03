{
  perSystem = { pkgs, lib, ... }: {
    packages.firecrawl = pkgs.stdenv.mkDerivation {
      pname = "firecrawl";
      version = "2.10";

      src = pkgs.fetchFromGitHub {
        owner = "firecrawl";
        repo = "firecrawl";
        rev = "v2.10";
        hash = lib.fakeHash;
      };

      installPhase = ''
        runHook preInstall
        mkdir -p $out/bin $out/share/firecrawl
        cp apps/api/.env.example $out/share/firecrawl/
        cp apps/api/samples/* $out/share/firecrawl/samples/ 2>/dev/null || true
        cat > $out/bin/firecrawl << 'SH'
        #!${pkgs.runtimeShell}
        exec ${pkgs.podman}/bin/podman run --rm -i --network=host \
          -e REDIS_URL="redis://127.0.0.1:6379" \
          -e PLAYWRIGHT_MICROSERVICE_URL="http://127.0.0.1:3000/scrape" \
          "ghcr.io/firecrawl/firecrawl:v2.10" "$@"
        SH
        chmod +x $out/bin/firecrawl
        runHook postInstall
      '';

      meta = {
        description = "The API to search, scrape, and interact with the web at scale";
        homepage = "https://firecrawl.dev";
        license = lib.licenses.agpl3Only;
        platforms = lib.platforms.linux;
        maintainers = with lib.maintainers; [ ];
      };
    };
  };
}
