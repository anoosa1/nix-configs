{
  perSystem = { pkgs, lib, ... }: {
    packages.stardew-valley = pkgs.stdenvNoCC.mkDerivation {
      pname = "stardew-valley";
      version = "1.6.15";

      src = pkgs.fetchurl {
        url = "https://hub.asherif.xyz/s/GT9TiKqD52xpBQe/download";
        name = "stardew_valley_1_6_15_24357_8705766150_78675.sh";
        hash = "sha256-mq50ltEZKJ8WF9apw9dJ83zTLNE+NNMgAVq8LBtVcO8=";
      };

      nativeBuildInputs = [ pkgs.zip pkgs.unzip pkgs.makeWrapper ];
      dontConfigure = true;
      dontBuild = true;
      dontFixup = true;

      sourceRoot = "source";
      unpackPhase = ''
        runHook preUnpack
        # The GOG installer is a ZIP with a shell script prepended.
        zip -q -F "$src" --out payload.zip
        unzip -q payload.zip 'data/noarch/*' -d "$sourceRoot"
        runHook postUnpack
      '';

      installPhase = ''
        runHook preInstall
        gameDir="$out/share/stardew-valley"
        mkdir -p "$gameDir"
        cp -R data/noarch/. "$gameDir/"

        # GOG's launcher sets permissions on startup. Do that before the store becomes read-only.
        sed -i -E 's/^[[:space:]]*chmod[[:space:]].*/:/' "$gameDir/start.sh"
        chmod +x "$gameDir/start.sh" "$gameDir/game/StardewValley"
        makeWrapper ${pkgs.steam-run}/bin/steam-run "$out/bin/stardew-valley" \
          --chdir "$gameDir" --add-flags "$gameDir/start.sh"
        runHook postInstall
      '';

      meta = {
        description = "Stardew Valley from the GOG Linux offline installer";
        homepage = "https://www.gog.com/en/game/stardew_valley";
        license = lib.licenses.unfree;
        mainProgram = "stardew-valley";
        platforms = [ "x86_64-linux" ];
      };
    };
  };
}
