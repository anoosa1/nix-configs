# modules/pkgs/bwmenu.nix
{
  perSystem = { pkgs, lib, ... }: {
    packages.bwmenu = pkgs.stdenvNoCC.mkDerivation {
      pname = "bwmenu";
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
        local name="bwmenu.sh"

        install -D $src/$name $out/bin/$name

        substituteInPlace $out/bin/$name \
          --replace-warn "/bin/sh" "${pkgs.dash}/bin/dash"

        wrapProgram $out/bin/$name \
          --prefix PATH : "${lib.makeBinPath [ pkgs.dash pkgs.coreutils pkgs.gawk pkgs.rbw pkgs.jq pkgs.bemenu pkgs.libnotify pkgs.wl-clipboard pkgs.wtype ]}"
      '';

      meta = with lib; {
        description = "Copy or autofill Bitwarden logins with bemenu";
        homepage = "https://git.asherif.xyz/anoosa1/scripts";
        mainProgram = "bwmenu.sh";
        license = lib.licenses.gpl3;
        platforms = lib.platforms.all;
        maintainers = with maintainers; [ anoosa ];
      };
    };
  };
}
