# modules/pkgs/4get.nix
{
  perSystem = { pkgs, lib, ... }: {
    packages."4get" = pkgs.stdenvNoCC.mkDerivation {
      pname = "4get";
      version = "1.0";
    
      src = pkgs.fetchFromGitea {
        domain = "git.lolcat.ca";
        owner = "lolcat";
        repo = "4get";
        rev = "master"; 
        sha256 = "sha256-cmlqZ7/tSQHuoZFm87es6Kg41WoTz+GREX/TtgPeQNM=";
      };
    
      dontUnpack = true;
      dontConfigure = true;
      dontBuild = true;
    
      installPhase = ''
        mkdir -p $out/share/4get
        cp -r $src/* $out/share/4get
      '';
    
      meta = with lib; {
        description = "4get is a proxy search engine that doesn't suck";
        homepage = "https://4get.ca/";
        license = lib.licenses.agpl3Plus;
        platforms = lib.platforms.all;
        maintainers = with maintainers; [ anoosa ];
      };
    };
  };
}
