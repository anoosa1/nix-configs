{
  flake.nixosModules.navidrome = {
    services = {
      navidrome = {
        enable = true;
        group = "anas";

        settings = {
          MusicFolder = "/home/anas/audio";
        };
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
    };
  };
}
