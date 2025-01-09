{
  pkgs,
  ...
}:

{
  sops = {
    secrets = {
      "transmission/settings.json" = {
        owner = "transmission";
      };
    };
  };

  services = {
    nginx.virtualHosts = {
      "torrent.asherif.xyz" = {
        forceSSL = true;
        enableACME = true;
        acmeRoot = null;
        locations."/" = {
          proxyPass = "http://localhost:9091";
          proxyWebsockets = true;
          extraConfig = "proxy_pass_header Authorization;";
        };
      };
    };
    transmission = {
      enable = true;
      webHome = pkgs.flood-for-transmission;
      settings = {
        umask = 007;
      };
      package = pkgs.transmission_4;
      downloadDirPermissions = "770";
      credentialsFile = "/run/secrets/transmission/settings.json";
    };
  };
}
