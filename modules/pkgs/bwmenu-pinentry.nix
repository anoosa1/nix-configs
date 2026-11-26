# modules/pkgs/bwmenu-pinentry.nix
{
  perSystem = { pkgs, lib, ... }: {
    packages.bwmenu-pinentry = pkgs.stdenvNoCC.mkDerivation {
      pname = "bwmenu-pinentry";
      version = "1.0";

      nativeBuildInputs = [
        pkgs.makeWrapper
      ];

      buildInputs = [
        pkgs.dash
      ];

      src = pkgs.fetchFromGitea {
        domain = "git.asherif.xyz";
        owner = "anoosa";
        repo = "scripts";
        rev = "master";
        sha256 = "sha256-EhpcgcZ3xsuMNw9x1G4lJmLaGSKib/OlGRLcwiBb4ng=";
      };

      dontUnpack = true;

      installPhase = ''
        local name="bwmenu-pinentry.sh"

        install -D $src/$name $out/bin/$name

        substituteInPlace $out/bin/$name \
          --replace-warn "/bin/sh" "${pkgs.dash}/bin/dash"

        wrapProgram $out/bin/$name \
          --prefix PATH : "${lib.makeBinPath [ pkgs.dash pkgs.coreutils pkgs.pass pkgs.bemenu ]}"
      '';

      meta = with lib; {
        description = "rbw pinentry that reads the master password from pass";
        homepage = "https://git.asherif.xyz/anoosa1/scripts";
        mainProgram = "bwmenu-pinentry.sh";
        license = lib.licenses.gpl3;
        platforms = lib.platforms.all;
        maintainers = with maintainers; [ anoosa ];
      };
    };
  };
}
