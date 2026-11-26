# modules/pkgs/define.nix
{
  perSystem = { pkgs, lib, ... }: {
    packages.define = pkgs.stdenvNoCC.mkDerivation {
      pname = "define";
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
        local name="define.sh"

        install -D $src/$name $out/bin/$name

        substituteInPlace $out/bin/$name \
          --replace-warn "/bin/sh" "${pkgs.dash}/bin/dash"

        wrapProgram $out/bin/$name \
          --prefix PATH : "${lib.makeBinPath [ pkgs.dash pkgs.libnotify pkgs.wl-clipboard pkgs.jq pkgs.curl ]}"
      '';

      meta = with lib; {
        description = "Define words";
        homepage = "https://git.asherif.xyz/anoosa1/scripts";
        mainProgram = "define.sh";
        license = lib.licenses.gpl3;
        platforms = lib.platforms.all;
        maintainers = with maintainers; [ anoosa ];
      };
    };
  };
}
