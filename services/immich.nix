{
  pkgs,
  ...
}:

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
          extraConfig = "proxy_pass_header Authorization;";
        };
      };
    };
    immich = {
      enable = true;
    };
  };
}
