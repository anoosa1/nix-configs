{
  sops = {
    secrets = {
      "cloudflare" = {
        owner = "acme";
      };
    };
  };

  ## security
  security = {
    acme = {
      acceptTerms = true;
      defaults = {
        email = "anas@asherif.xyz";
        dnsProvider = "cloudflare";
        dnsResolver = "1.1.1.1:53";
        dnsPropagationCheck = true;
        credentialFiles = {
          "CF_DNS_API_TOKEN_FILE" = "/run/secrets/cloudflare";
        };
      };
    };

    pam = {
      services = {
        swaylock = {};

        su = {
          requireWheel = true;
        };

        system-login = {
          failDelay = {
            enable = true;
            delay = 4000000;
          };
        };

        greetd = {
          gnupg = {
            enable = true;
            storeOnly = true;
            noAutostart = true;
          };
        };
      };
    };

    # polkit
    polkit = {
      enable = true;
    };

    # rtkit
    rtkit = {
      enable = true;
    };
  };
}
