{
  pkgs,
  ...
}:

{
  services = {
    nginx.virtualHosts = {
      "auth1.asherif.xyz" = {
        forceSSL = true;
        enableACME = true;
        acmeRoot = null;
        locations."/" = {
          proxyPass = "http://localhost:8080";
          proxyWebsockets = true;
          extraConfig = "proxy_pass_header Authorization;";
        };
      };
    };
    zitadel = {
      enable = true;
      masterKeyFile = /home/anas/docs/flakes/nix-configs/services/zitadelkey;
    };
  };
}
