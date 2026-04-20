{ inputs, self, ... }: {
  flake.nixosConfigurations.astra = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.anas
      self.nixosModules.astra
      self.nixosModules.nixos
      self.nixosModules.server
      self.nixosModules.ssh
    ];
  };

  flake.nixosModules.astra = { lib, ... }: {
    imports = [
      inputs.disko.nixosModules.disko
    ];

    boot = {
      kernelModules = [ "kvm-intel" ];
      extraModulePackages = [ ];
      supportedFilesystems = [  ];

      loader = {
        timeout = 0;
  
        systemd-boot = {
          enable = true;
          editor = false;
        };
  
        efi = {
          canTouchEfiVariables = true;
        };
      };
  
    };

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

                      "/swap" = {
                        mountpoint = "/.swap";

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

          data = {
            type = "disk";
            device = "/dev/disk/by-id/ata-ST500DM002-1BD142_Z6EEASRB";

            content = {
              type = "gpt";

              partitions = {
                data = {
                  size = "100%";

                  content = {
                    extraArgs = [ "-f" ];
                    type = "btrfs";

                    subvolumes = {
                      "/data" = {
                        mountpoint = "/data";

                        mountOptions = [
                          "compress=zstd"
                          "noatime"
                        ];
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
      useNetworkd = true;
      useDHCP = lib.mkDefault true;

      hosts = {
        "127.0.0.1" = [ "search.asherif.xyz" "hub.asherif.xyz" "accounts.asherif.xyz" "git.asherif.xyz" "x.asherif.xyz" "auth.asherif.xyz" "qbit.asherif.xyz" ];
      };

      # firewall
      firewall = {
        enable = true;
        allowPing = false;
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
