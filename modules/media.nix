{
  flake.nixosModules.media = { pkgs, ... }: {
    sops = {
      secrets = {
        "transmission" = {
          owner = "transmission";
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
                  proxy_set_header Accept-Encoding "";
                  sub_filter '</head>' '<link rel="stylesheet" type="text/css" href="https://theme-park.dev/css/base/transmission/catppuccin-mocha.css"></head>';
                  sub_filter_once on;
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
                proxyPass = "http://localhost:9091";
                proxyWebsockets = true;
              };
            };
          };
        };
      };

      transmission = {
        enable = true;
        credentialsFile = "/run/secrets/transmission";
        downloadDirPermissions = "750";
        package = pkgs.transmission_4;

        settings = {
          umask = 027;
          rpc-username = "anas";
          rpc-authentication-required = true;
        };
      };
    };
  };
}
