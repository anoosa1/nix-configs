{
  sops = {
    secrets = {
      "peertube/secrets" = {
        owner = "peertube";
      };
    };
  };

  services = {
    nginx.virtualHosts = {
      "videos.asherif.xyz" = {
        forceSSL = true;
        enableACME = true;
        acmeRoot = null;
      };
    };

    peertube = {
      enable = true;
      localDomain = "videos.asherif.xyz";
      listenWeb = 443;
      enableWebHttps = true;
      configureNginx = true;

      redis = {
        createLocally = true;
      };

      database = {
        createLocally = true;
      };

      secrets = {
        secretsFile = "/run/secrets/peertube/secrets";
      };
    };
  };
}
