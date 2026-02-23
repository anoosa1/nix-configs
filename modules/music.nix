{
  flake.nixosModules.music = {
    sops = {
      secrets = {
        slskd = {
          owner = "slskd";
        };
      };
    };

    services = {
      navidrome = {
        enable = true;

        settings = {
          EnableTranscodingConfig = true;
        };
      };

      slskd = {
        enable = true;
        domain = "music.asherif.xyz";
        environmentFile = "/run/secrets/slskd";

        settings = {
          web = {
            url_base = "/slskd";
          };

          shares = {
            directories = [
              "/var/lib/slskd/share"
            ];
          };
        };

        nginx = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
        };
      };

      nginx.virtualHosts."music.asherif.xyz" = {
        forceSSL = true;
        enableACME = true;
        acmeRoot = null;

        locations = {
          "/" = {
            proxyPass = "http://localhost:4533";
            proxyWebsockets = true;
          };
        };
      };
    };
  };
}
