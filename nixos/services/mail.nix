{
  sops = {
    secrets = {
      "postfix/smtp-relay" = {
        owner = "postfix";
      };
    };
  };

  mailserver = {
    enable = true;
    fqdn = "mail.asherif.xyz";
    domains = [ "asherif.xyz" ];
    certificateScheme = "acme";
    hierarchySeparator = "/";
    indexDir = "/var/lib/dovecot/indices";
    messageSizeLimit = 52428800;
    useFsLayout = true;
    virusScanning = true;
    dkimKeyBits = 2048;

    loginAccounts = {
      "anas@asherif.xyz" = {
        name = "anas";
        hashedPassword = "$2b$05$A30nAIvkYLsm0bY4lqCf7exhDRTn3n6S2A0wZb.zb9cFzhMuKJSfW";
        aliases = ["@asherif.xyz"];
      };
    };

    fullTextSearch = {
      enable = true;
    };
  };

  services = {
    postfix = {
      config = {
        #relayhost = "[in-v3.mailjet.com]:587";
        #smtp_sasl_auth_enable          = "yes";
        #smtp_sasl_password_maps        = "hash:/var/lib/postfix/smtp-relay";
        #smtp_sasl_security_options     = "noanonymous";
        #smtp_sasl_tls_security_options = "noanonymous";
      };
    };
  };
}
