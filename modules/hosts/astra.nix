{ inputs, self, ... }: {
  flake.nixosConfigurations.astra = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.anas
      self.nixosModules.astra
      self.nixosModules.nixos
      self.nixosModules.server
      self.nixosModules.ssh

      (inputs.nixpkgs + "/nixos/modules/virtualisation/proxmox-lxc.nix")
    ];
  };

  flake.nixosModules.astra = {
    imports = [
      inputs.disko.nixosModules.disko
    ];

    disko = {
      devices = {
        disk = {
          main = {
            type = "disk";
            device = "/dev/disk/by-id/ata-Axiom_C560_Series_SSD_AX170303100342E79";

            content = {
              type = "gpt";

              partitions = {
                ESP = {
                  priority = 1;
                  name = "ESP";
                  start = "1M";
                  end = "128M";
                  type = "EF00";

                  content = {
                    type = "filesystem";
                    format = "vfat";
                    mountpoint = "/boot";
                    mountOptions = [ "umask=0077" ];
                  };
                };

                root = {
                  size = "100%";

                  content = {
                    extraArgs = [ "-f" ]; # Override existing partition
                    type = "btrfs";

                    subvolumes = {
                      "/root" = {
                        mountpoint = "/";

                        mountOptions = [
                          "compress=zstd"
                          "noatime"
                        ];
                      };

                      "/nix" = {
                        mountpoint = "/nix";

                        mountOptions = [
                          "compress=zstd"
                          "noatime"
                        ];
                      };
                    };

                    swap = {
                      swapfile = {
                        size = "16G";
                      };
                    };
                  };
                };
              };
            };
          };
        };
      };
    };

    ## networking
    networking = {
      hostName = "astra";
      nameservers = [ "100.100.100.100" "1.1.1.1" "1.0.0.1" ];
      search = [ "tail999916.ts.net" ];
      useDHCP = false;

      hosts = {
        "10.0.0.244" = [ "search.asherif.xyz" "hub.asherif.xyz" "accounts.asherif.xyz" "git.asherif.xyz" "x.asherif.xyz" "auth.asherif.xyz" "qbit.asherif.xyz" ];
      };

      interfaces."eth0@if200" = {
        ipv4.addresses = [{
          address = "10.0.0.244";
          prefixLength = 24;
        }];
      };
    };

    services = {
      tailscale.interfaceName = "userspace-networking";
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
