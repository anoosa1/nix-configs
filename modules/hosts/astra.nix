{ inputs, self, ... }: {
  flake.nixosConfigurations.astra = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.astra
      self.nixosModules.desktop
      self.nixosModules.nixos
      self.nixosModules.server

      (inputs.nixpkgs + "/nixos/modules/virtualisation/proxmox-lxc.nix")
    ];
  };

  flake.nixosModules.astra = {
    sops = {
      secrets = {
        "cloudflare" = {
          owner = "acme";
        };
      };
    };

    anoosa = {
      "4get".enable = true;
      code-server.enable = true;
      gitea.enable = true;
      home-assistant.enable = true;
      immich.enable = true;
      librechat.enable = true;
      nextcloud.enable = true;
      nitter.enable = true;
      paperless.enable = true;
      searx.enable = true;
      soft-serve.enable = true;
      ssh.enable = true;
      transmission.enable = true;
      vaultwarden.enable = true;
    };

    ## networking
    networking = {
      hostName = "astra";
      nameservers = [ "100.100.100.100" "1.1.1.1" "1.0.0.1" ];
      search = [ "tail999916.ts.net" ];
      useDHCP = false;

      hosts = {
        "10.0.0.244" = [ "search.asherif.xyz" "hub.asherif.xyz" "accounts.asherif.xyz" "git.asherif.xyz" "x.asherif.xyz" ];
      };

      interfaces."eth0@if200" = {
        ipv4.addresses = [{
          address = "10.0.0.244";
          prefixLength = 24;
        }];
      };
    };

    services = {
      nginx = {
        recommendedTlsSettings = true;
        recommendedProxySettings = true;

        virtualHosts = {
          "accounts.asherif.xyz" = {
            forceSSL = true;
            enableACME = true;
            acmeRoot = null;
            locations = {
              "/" = {
                proxyPass = "https://10.0.0.2:9443";
                proxyWebsockets = true;
              };
              "~ (/authentik)?/api" = {
                proxyPass = "https://10.0.0.2:9443";
                proxyWebsockets = true;
              };
            };
          };

          "p1.asherif.xyz" = {
            forceSSL = true;
            enableACME = true;
            acmeRoot = null;
            locations = {
              "/" = {
                proxyPass = "https://10.0.0.10:8006";
                proxyWebsockets = true;
              };
            };
          };
        };
      };

      # smb
      samba = {
        enable = true;
        openFirewall = true;
        settings = {
          default = {
            "workgroup" = "WORKGROUP";
            "server string" = "astra";
            "netbios name" = "astra";
            "security" = "user";
            "use sendfile" = "yes";
            "hosts allow" = "10.0.0.235 10.0.0.228 127.0.0.1 localhost";
            "hosts deny" = "0.0.0.0/0";
            "guest account" = "nobody";
            "map to guest" = "bad user";
          };
          yousof = {
            path = "/export/yousof";
            browseable = "yes";
            "read only" = "no";
            "guest ok" = "no";
            "create mask" = "0600";
            "directory mask" = "0700";
            "force user" = "anas";
            "force group" = "anas";
          };
        };
      };
    };

    # security settings
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
    };
  };
}
