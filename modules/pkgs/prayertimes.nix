# modules/pkgs/prayertimes.nix
{
  perSystem = { pkgs, lib, ... }: {
    packages.prayertimes = (pkgs.fetchNextcloudApp {
      appName = "prayertimes";
      appVersion = "1.0.0";
      url = "https://git.asherif.xyz/anoosa/prayertimes/archive/main.tar.gz";
      sha256 = "sha256-jn+U6pEqp3STTBf/Eugz+4xivjFpYI0jCfUnv5dnrgc=";
      license = "agpl3Plus";
      unpack = true;
      description = "Nextcloud Prayer Times App";
      homepage = "https://git.asherif.xyz/anoosa/prayertimes";
      maintainers = with lib.maintainers; [ anoosa ];
    }).overrideAttrs (oldAttrs: {
      postPatch = ''
        substituteInPlace appinfo/info.xml \
          --replace-fail 'max-version="31"' 'max-version="33"'
      '';
    });
  };
}

