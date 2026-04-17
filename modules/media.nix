{
  flake.nixosModules.media = {
    sops = {
      secrets = {
        "qui" = {
          owner = "qui";
        };
      };
    };

    services = {
      immich = {
        enable = true;
      };

      nginx = {
        virtualHosts = {
          "photos.asherif.xyz" = {
            forceSSL = true;
            enableACME = true;
            acmeRoot = null;

            locations = {
              "/" = {
                proxyPass = "http://localhost:2283";
                proxyWebsockets = true;

                extraConfig = ''
                  client_max_body_size 10G;
                '';
              };
            };
          };

          "qbit.asherif.xyz" = {
            forceSSL = true;
            enableACME = true;
            acmeRoot = null;

            locations = {
              "/" = {
                proxyPass = "http://localhost:9251";
                proxyWebsockets = true;
              };
            };
          };

          "torrent.asherif.xyz" = {
            forceSSL = true;
            enableACME = true;
            acmeRoot = null;

            locations = {
              "/" = {
                proxyPass = "http://localhost:7476";
                proxyWebsockets = true;
              };
            };
          };
        };
      };

      qbittorrent = {
        enable = true;
        webuiPort = 9251;
      };

      qui = {
        enable = true;
        secretFile = "/run/secrets/qui";
      };
    };
  };
}
