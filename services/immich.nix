{
  services = {
    nginx.virtualHosts = {
      "photos.asherif.xyz" = {
        forceSSL = true;
        enableACME = true;
        acmeRoot = null;
        locations."/" = {
          proxyPass = "http://localhost:2283";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_pass_header Authorization;
            client_max_body_size 10G;
          '';
        };
      };
    };
    immich = {
      enable = true;
    };
  };
}
