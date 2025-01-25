{
  pkgs,
  sops,
  ...
}:

{
  sops = {
      "cloudflare" = {
        owner = "acme";
      };
    };
  };

  networking = {
    interfaces."br0".ipv4.addresses = [{
      address = "10.0.0.20";
      prefixLength = 24;
    }]
    defaultGateway = "10.0.0.1";
  };

  containers = {
    kasmweb = {
      autoStart = true;
      privateNetwork = true;
      localAddress = "10.0.0.20/24";
      hostBridge = "br0";

      config = { config, pkgs, lib, ... }: {
    
        services = {
          kasmweb = {
            enable = true;
            networkSubnet = "10.0.1.0/24";
          };

          resolved = {
            enable = true;
          };
        };
      };
    };
  };

  #security = {
  #  acme = {
  #    acceptTerms = true;
  #    defaults = {
  #      email = "anas@asherif.xyz";
  #      dnsProvider = "cloudflare";
  #      dnsResolver = "1.1.1.1:53";
  #      dnsPropagationCheck = true;
  #      credentialFiles = {
  #        "CF_DNS_API_TOKEN_FILE" = "/run/secrets/cloudflare";
  #      };
  #    };
  #  };
  #};

  #services = {
  #  nginx.virtualHosts = {
  #    "kasm.asherif.xyz" = {
  #      forceSSL = true;
  #      enableACME = true;
  #      acmeRoot = null;
  #    };
  #  };
  #};
}
