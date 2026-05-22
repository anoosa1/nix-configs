# modules/pkgs/antigravity-cli.nix
{
  perSystem = { pkgs, lib, ... }: {
    packages.antigravity-cli = pkgs.stdenvNoCC.mkDerivation {
      pname = "antigravity-cli";
      version = "1.0";

      src = pkgs.fetchurl {
        url = "https://storage.googleapis.com/antigravity-public/antigravity-cli/1.0.0-5288553236791296/linux-x64/cli_linux_x64.tar.gz";
        sha256 = "sha256-cAljQFdPr8SgbE08gFcxTiLUdc4cgg0K1R/wf7fpnrY=";
      };

      sourceRoot = ".";

      nativeBuildInputs = [ pkgs.autoPatchelfHook ];

      installPhase = ''
        runHook preInstall
        mkdir -p $out/bin
        cp antigravity $out/bin/agy
        chmod +x $out/bin/agy
        runHook postInstall
      '';

      meta = with lib; {
        description = "Command line interface tool for the Antigravity suite";
        homepage = "https://antigravity.google/";
        license = licenses.unfree;
        platforms = platforms.all;
        maintainers = with maintainers; [ anoosa ];
      };
    };
  };
}
