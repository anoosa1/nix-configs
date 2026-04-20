{
  inputs,
  self,
  ...
}: {
  flake.nixosConfigurations.aurora = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.aurora
      self.nixosModules.anas
      self.nixosModules.desktop
      self.nixosModules.nixos
      self.nixosModules.ssh
    ];
  };

  flake.nixosModules.aurora = { pkgs, lib, ... }: {
    imports = [
      inputs.disko.nixosModules.disko
      inputs.impermanence.nixosModules.impermanence
    ];

    programs = {
      gamescope = {
        enable = true;
      };

      gamemode = {
        enable = true;
        enableRenice = true;
      };

      steam = {
        enable = true;
        extraCompatPackages = [ pkgs.proton-ge-bin ];
      };
    };

    hardware = {
      bluetooth = {
        enable = true;
      };

      graphics = {
        enable32Bit = true;
      };
    };

    boot = {
      kernelPackages = pkgs.linuxPackages_latest;
      kernelModules = [ "kvm-amd" ];
      extraModulePackages = [ ];
      supportedFilesystems = [ "ntfs" ];

      initrd = {
        availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
        kernelModules = [ ];

        #systemd = {
        #  services = {
        #    impermance-btrfs-rolling-root = {
        #      description = "Archiving existing BTRFS root subvolume and creating a fresh one";
        #      # Specify dependencies explicitly
        #      unitConfig.DefaultDependencies = false;
        #      # The script needs to run to completion before this service is done
        #      serviceConfig = {
        #        Type = "oneshot";
        #        # NOTE: to be able to see errors in your script do this
        #        # StandardOutput = "journal+console";
        #        # StandardError = "journal+console";
        #      };
        #      # This service is required for boot to succeed
        #      requiredBy = ["initrd.target"];
        #      # Should complete before any file systems are mounted
        #      before = ["sysroot.mount"];
  
        #      # Wait until the root device is available
        #      # If you're altering a different device, specify its device unit explicitly.
        #      # see: systemd-escape(1)
        #      requires = ["initrd-root-device.target"];
        #      after = [
        #        "initrd-root-device.target"
        #        # Allow hibernation to resume before trying to alter any data
        #        "local-fs-pre.target"
        #      ];
  
        #      script = ''
        #        mkdir /btrfs_tmp
        #        mount/dev/disk/by-id/ata-LITEONIT_LCS-128L9S-11_2.5_7mm_128GB_TW0XRV8D550854921081-part2 /btrfs_tmp

        #        if [[ -e /btrfs_tmp/root ]]; then
        #            mkdir -p /btrfs_tmp/old_roots
        #            timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
        #            mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
        #        fi

        #        delete_subvolume_recursively() {
        #            IFS=$'\n'
        #            for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
        #                delete_subvolume_recursively "/btrfs_tmp/$i"
        #            done
        #            btrfs subvolume delete "$1"
        #        }

        #        for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
        #            delete_subvolume_recursively "$i"
        #        done

        #        btrfs subvolume create /btrfs_tmp/root
        #        umount /btrfs_tmp
        #      '';
        #    };
        #  };

        #  extraBin = {
        #    "mkdir" = "${pkgs.coreutils}/bin/mkdir";
        #    "date" = "${pkgs.coreutils}/bin/date";
        #    "stat" = "${pkgs.coreutils}/bin/stat";
        #    "mv" = "${pkgs.coreutils}/bin/mv";
        #    "find" = "${pkgs.findutils}/bin/find";
        #    "btrfs" = "${pkgs.btrfs-progs}/bin/btrfs";
        #  };
        #};
      };
    };

    disko = {
      devices = {
        disk = {
          main = {
            type = "disk";
            device = "/dev/disk/by-id/ata-LITEONIT_LCS-128L9S-11_2.5_7mm_128GB_TW0XRV8D550854921081";

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
                  };
                };
              };
            };
          };

          nvme = {
            type = "disk";
            device = "/dev/disk/by-id/nvme-nvme.1dee-484253453239333132343031343330-485020535344204558393230203235364742-00000001";

            content = {
              type = "gpt";

              partitions = {
                home = {
                  size = "100%";

                  content = {
                    extraArgs = [ "-f" ];
                    mountpoint = "/home";
                    type = "btrfs";

                    subvolumes = {
                      "/anas" = {
                        mountOptions = [
                          "compress=zstd"
                          "noatime"
                        ];
                      };

                      "/persist" = {
                        mountpoint = "/nix/persist";

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

    fileSystems."/nix/persist".neededForBoot = true;

    networking = {
      hostName = "aurora";
    };

    console = {
      font = "${pkgs.terminus_font}/share/consolefonts/ter-i16n.psf.gz";
    };

    ## environment
    environment = {
      persistence = {
        "/nix/persist" = {
          enable = true;
          hideMounts = true;

          directories = [
            "/var/log"
            "/var/lib/bluetooth"
            "/var/lib/nixos"
            "/var/lib/systemd/coredump"
            "/etc/NetworkManager/system-connections"
            { directory = "/var/lib/colord"; user = "colord"; group = "colord"; mode = "u=rwx,g=rx,o="; }
          ];

          files = [
            "/etc/machine-id"
          ];

          #users.bird = {
          #  directories = [
          #    "dls"
          #    "audio"
          #    "pics"
          #    "docs"
          #    "vids"
          #    { directory = ".gnupg"; mode = "0700"; }
          #    { directory = ".ssh"; mode = "0700"; }
          #    { directory = ".local/share/keyrings"; mode = "0700"; }
          #  ];
          #};
        };
      };

      # system packages
      systemPackages = [
        pkgs.bluetui
        pkgs.steam-tui
        pkgs.steamcmd
      ];
    };

    services = {
      xserver = {
        videoDrivers = [ "nvidia" ];
      };
    };

    hardware = {
      cpu.amd.updateMicrocode = true;

      # nvidia - gpu
      nvidia = {
        open = true;

        powerManagement = {
          enable = true;
        };
      };
    };
  };
}
