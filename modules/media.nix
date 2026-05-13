{
  flake.nixosModules.media = {
    sops = {
      secrets = {
        "kavita" = {
          owner = "kavita";
        };
      };
    };

    services = {
      kavita = {
        enable = true;
        tokenKeyFile = "/run/secrets/kavita";
      };

      immich = {
        enable = true;
      };

      nginx = {
        virtualHosts = {
          "books.asherif.xyz" = {
            forceSSL = true;
            enableACME = true;
            acmeRoot = null;

            locations = {
              "/" = {
                proxyPass = "http://localhost:5000";
                proxyWebsockets = true;
              };
            };
          };

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

          "torrent.asherif.xyz" = {
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
        };
      };

      qbittorrent = {
        enable = true;
        webuiPort = 9251;
      };
    };
  };
}
