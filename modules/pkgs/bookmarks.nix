# modules/pkgs/bookmarks.nix
{
  perSystem = { pkgs, lib, ... }: {
    packages.bookmarks = pkgs.stdenvNoCC.mkDerivation {
      pname = "bookmarks";
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
        local name="bookmarks.sh"

        install -D $src/$name $out/bin/$name

        substituteInPlace $out/bin/$name \
          --replace-warn "/bin/sh" "${pkgs.dash}/bin/dash"

        wrapProgram $out/bin/$name \
          --prefix PATH : "${lib.makeBinPath [ pkgs.dash pkgs.libnotify pkgs.wl-clipboard pkgs.bemenu ]}"
      '';

      meta = with lib; {
        description = "Bookmark stuff with bemenu";
        homepage = "https://git.asherif.xyz/anoosa1/scripts";
        mainProgram = "bookmarks.sh";
        license = lib.licenses.gpl3;
        platforms = lib.platforms.all;
        maintainers = with maintainers; [ anoosa ];
      };
    };
  };
}
