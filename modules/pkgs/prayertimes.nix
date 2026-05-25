# modules/pkgs/prayertimes.nix
{
  perSystem = { pkgs, lib, ... }: {
    packages.prayertimes = pkgs.fetchNextcloudApp {
      appName = "prayertimes";
      appVersion = "1.0.0";
      url = "https://git.asherif.xyz/anoosa/prayertimes/archive/main.tar.gz";
      sha256 = "sha256-BI1tDCqs11MvJK3U1ky2/YD26dPnwnFcM7VFdGuDgbU=";
      license = "agpl3Plus";
      unpack = true;
      description = "Nextcloud Prayer Times App";
      homepage = "https://git.asherif.xyz/anoosa/prayertimes";
      maintainers = with lib.maintainers; [ anoosa ];
    };
  };
}

