{
  pkgs,
  sops,
  ...
}:

{
  services = {
    nginx.virtualHosts = {
      "kasm.asherif.xyz" = {
        forceSSL = true;
        enableACME = true;
        acmeRoot = null;
        locations."/" = {
          proxyPass = "https://localhost:8443";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_pass_header Authorization;
            proxy_set_header Host $host;
          '';
        };
      };
    };
    kasmweb = {
      enable = true;
      networkSubnet = "10.0.1.0/24";
      listenPort = 8443;
      sslCertificate = "/kasm.asherif.xyz/cert.pem";
      sslCertificateKey = "/kasm.asherif.xyz/key.pem";
    };
  };
}
