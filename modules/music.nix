{
  flake.nixosModules.music = {
    services = {
      navidrome = {
        enable = true;
        group = "anas";

        settings = {
          MusicFolder = "/home/anas/audio";
        };
      };

      slskd = {
        enable = true;
      };

      nginx.virtualHosts."music.asherif.xyz" = {
        forceSSL = true;
        enableACME = true;
        acmeRoot = null;

        locations."/" = {
          proxyPass = "http://localhost:4533";
          proxyWebsockets = true;
        };
      };

      nginx.virtualHosts."slskd.asherif.xyz" = {
        forceSSL = true;
        enableACME = true;
        acmeRoot = null;

        locations."/" = {
          proxyPass = "http://localhost:5030";
          proxyWebsockets = true;
        };
      };
    };
  };
}
