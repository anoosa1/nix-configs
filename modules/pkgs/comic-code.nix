# modules/pkgs/comic-code.nix
{
  perSystem = { pkgs, lib, ... }: {
    packages.comic-code = pkgs.stdenvNoCC.mkDerivation {
      pname = "comic-code";
      version = "1.0";

      src = pkgs.fetchFromGitea {
        domain = "git.asherif.xyz";
        owner = "anoosa";
        repo = "comic-code";
        rev = "master"; 
        sha256 = "sha256-h9aOHl5zDEL5xkVp14OJzIdiJD1VKp2wub1aswAWqFs=";
      };

      dontUnpack = true;
      dontConfigure = true;
      dontBuild = true;

      installPhase = ''
        runHook preInstall
        install -Dm444 --target $out/share/fonts/opentype $src/*.otf
        runHook postInstall
      '';

      meta = with lib; {
        description = "Comic Code programming font (paid)";
        homepage = "https://tosche.net/fonts/comic-code";
        license = lib.licenses.fontException;
        platforms = lib.platforms.all;
        maintainers = with maintainers; [ anoosa ];
      };
    };
  };
}
