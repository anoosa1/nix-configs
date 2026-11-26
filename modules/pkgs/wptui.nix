# modules/pkgs/wptui.nix
{
  perSystem = { pkgs, lib, ... }: let
    version = "0.3.0";

    src = pkgs.fetchFromGitHub {
      owner = "Andiveli";
      repo = "wptui";
      tag = "v${version}";
      hash = "sha256-B1nPH9DVspmiF2JocHjkfo4aZSTKACGE7qsYNakutMY=";
    };

    # whatsmeow bridge, linked statically into the Rust binary
    whatsrust-libgo = pkgs.buildGoModule {
      pname = "whatsrust-libgo";
      inherit version src;

      sourceRoot = "${src.name}/whatsrust/lib";

      vendorHash = "sha256-y9y0KJoiwvwPoFGMf9RRrQDl6sSJmkWqyGaxHTEBX8E=";

      buildPhase = ''
        runHook preBuild

        go build -buildmode=c-archive -o libgo.a

        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall

        install -Dm644 libgo.a $out/lib/libgo.a

        runHook postInstall
      '';

      doCheck = false;
    };
  in {
    packages.wptui = pkgs.rustPlatform.buildRustPackage {
      pname = "wptui";
      inherit version src;

      cargoHash = "sha256-SPEkWnIa8kQbuXiYpuN7rNYm4tKjmu6PlXZ3LVzKZJY=";

      env.WHATSRUST_LIBGO = "${whatsrust-libgo}/lib/libgo.a";

      nativeBuildInputs = [
        pkgs.pkg-config
      ];

      buildInputs = [
        pkgs.chafa
        pkgs.glib
        pkgs.wayland
        pkgs.mpv
        pkgs.sqlite
      ];

      meta = with lib; {
        description = "Keyboard-driven WhatsApp client for the terminal";
        homepage = "https://github.com/Andiveli/wptui";
        license = licenses.mit;
        platforms = platforms.linux;
        mainProgram = "wp-tui";
      };
    };
  };
}
