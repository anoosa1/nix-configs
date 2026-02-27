# modules/pkgs/handler.nix
{
  perSystem = { pkgs, lib, ... }: {
    packages.handler = pkgs.stdenvNoCC.mkDerivation {
      pname = "handler";
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
        sha256 = "sha256-SQWrFl26jALAmjGsAGMmybbo9R6tqYQ/xRDpUIZb7Lk=";
      };

      dontUnpack = true;

      installPhase = ''
        local name="handler.sh"

        install -D $src/$name $out/bin/$name

        substituteInPlace $out/bin/$name \
          --replace-warn "/bin/sh" "${pkgs.dash}/bin/dash"

        wrapProgram $out/bin/$name \
          --prefix PATH : "${lib.makeBinPath [ pkgs.dash pkgs.yt-dlp pkgs.libnotify pkgs.wl-clipboard pkgs.curlMinimal pkgs.mpv pkgs.imv pkgs.elinks pkgs.zathura pkgs.ts ]}"
      '';

      meta = with lib; {
        description = "Queue and download";
        homepage = "https://git.asherif.xyz/anoosa1/scripts";
        license = lib.licenses.gpl3;
        platforms = lib.platforms.all;
        maintainers = with maintainers; [ anoosa ];
      };
    };
  };
}
