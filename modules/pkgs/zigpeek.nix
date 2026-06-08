# modules/pkgs/zigpeek.nix
{
  perSystem = { pkgs, lib, ... }: let
    python3Packages = pkgs.python3Packages.override {
      overrides = self: super: {
        wasmtime = super.wasmtime.overridePythonAttrs (old: {
          doCheck = false;
        });
      };
    };
  in {
    packages.zigpeek = python3Packages.buildPythonApplication {
      pname = "zigpeek";
      version = "0.4.1";

      src = pkgs.fetchzip {
        name = "zigpeek-source";
        url = "https://github.com/TanGentleman/zigpeek/archive/main.tar.gz";
        hash = "sha256-/nQ39diCqvZA2xGz8jlvIpmUj35lmWjshKvG/MEU1ck=";
      };

      format = "pyproject";

      nativeBuildInputs = with python3Packages; [
        hatchling
        pkgs.makeWrapper
      ];

      # Strip the offline optional dep and uv workspace sections.
      # Each sed deletes from the section header to (but not including)
      # the next section header by using { /^\[/!d }.
      postPatch = ''
        # Remove [project.optional-dependencies] section
        sed -i '/^\[project.optional-dependencies\]/,/^\[/{
          /^\[project.optional-dependencies\]/d
          /^\[/!d
        }' pyproject.toml

        # Remove [dependency-groups] section
        sed -i '/^\[dependency-groups\]/,/^\[/{
          /^\[dependency-groups\]/d
          /^\[/!d
        }' pyproject.toml

        # Remove [tool.uv.workspace] section
        sed -i '/^\[tool\.uv\.workspace\]/,/^\[/{
          /^\[tool\.uv\.workspace\]/d
          /^\[/!d
        }' pyproject.toml

        # Remove [tool.uv.sources] section
        sed -i '/^\[tool\.uv\.sources\]/,/^\[/{
          /^\[tool\.uv\.sources\]/d
          /^\[/!d
        }' pyproject.toml
      '';

      propagatedBuildInputs = with python3Packages; [
        wasmtime
        httpx
        beautifulsoup4
        lxml
      ];

      pipInstallFlags = [ "--no-deps" ];

      # Relax version constraints where nixpkgs ships a newer minor/patch.
      # - lxml: nixpkgs has 6.0.2 but spec says ~=6.1.0 (6.0.x vs 6.1.x, compatible)
      # - wasmtime: nixpkgs has 45.0.0 but spec says ~=44.0.0 (backward compatible API)
      pythonRelaxDeps = [ "lxml" "wasmtime" ];

      # Verify entry point exists. buildPythonApplication with
      # format=pyproject should create console_scripts from
      # [project.scripts] automatically. Fallback if missing.
      postInstall = ''
        if [ ! -f "$out/bin/zigpeek" ]; then
          echo "zigpeek entry point not auto-created, adding wrapper"
          mkdir -p "$out/bin"
          makeWrapper "${pkgs.python3.interpreter}" "$out/bin/zigpeek" \
            --add-flags "-m zigpeek.cli" \
            --prefix PYTHONPATH : "$out/lib/${pkgs.python3.libPrefix}/site-packages"
        fi
      '';

      meta = with lib; {
        description = "Fast CLI for Zig 0.16 stdlib + Skill for coding agents";
        homepage = "https://github.com/TanGentleman/zigpeek";
        license = licenses.mit;
        platforms = platforms.linux;
        mainProgram = "zigpeek";
      };
    };
  };
}
