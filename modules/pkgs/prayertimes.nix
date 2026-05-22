# modules/pkgs/prayertimes.nix
{
  perSystem = { pkgs, lib, ... }: {
    packages.prayertimes = pkgs.stdenvNoCC.mkDerivation {
      pname = "prayertimes";
      version = "1.0.0";

      src = pkgs.fetchFromGitea {
        domain = "git.asherif.xyz";
        owner = "anoosa";
        repo = "prayertimes";
        rev = "main";
        sha256 = "sha256-tFWjNZzFi8Jy79GjvqN7POE+cPkwd1XaGUaGZ7u3AVo=";
      };

      dontConfigure = true;
      dontBuild = true;

      postPatch = ''
        substituteInPlace appinfo/info.xml \
          --replace-fail 'max-version="31"' 'max-version="33"'
      '';

      installPhase = ''
        mkdir -p $out
        cp -r appinfo css js lib templates img $out/
      '';

      meta = with lib; {
        description = "Nextcloud Prayer Times App";
        homepage = "https://git.asherif.xyz/anoosa/prayertimes";
        license = licenses.agpl3Plus;
        platforms = platforms.all;
        maintainers = with maintainers; [ anoosa ];
      };
    };
  };
}
