{
  flake.nixosModules.media = {
    sops = {
      secrets = {
        "kavita/token" = {
          owner = "kavita";
        };

        "kavita/client_secret" = {
          owner = "kavita";
        };
      };
    };

    services = {
      kavita = {
        enable = true;

        credentials = {
          token = "/run/secrets/kavita/token";
          client_secret = "/run/secrets/kavita/client_secret";
        };

        settings = {
          TokenKey = "@token@";

          OpenIdConnectSettings = {
            Authority = "https://auth.asherif.xyz";
            ClientId = "kavita";
            Enabled = true;
            Secret = "@client_secret@";
          };
        };
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
