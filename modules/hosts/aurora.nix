{ inputs, self, ... }: {
  flake.nixosConfigurations.aurora = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.aurora
      self.nixosModules.desktop
      self.nixosModules.nixos
      self.nixosModules.stylix
    ];
  };

  flake.nixosModules.aurora = { pkgs }: {
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

    boot = {
      kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto-x86_64-v3;
      kernelModules = [ "kvm-amd" ];
      extraModulePackages = [ ];

      initrd = {
        availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
        kernelModules = [ ];
      };
    };

    fileSystems = {
      "/" = {
        device = "/dev/disk/by-uuid/830590b1-805d-4037-9224-4bf48598df66";
        fsType = "ext4";
      };

      "/boot" = {
        device = "/dev/disk/by-uuid/06DB-D2D6";
        fsType = "vfat";
      };

      "/home/anas/.local/media/data" = {
        device = "/dev/disk/by-uuid/01DA2B0CD38FCEB0";
        fsType = "ntfs3";

        options = [
          "x-gvfs-show"
          "nofail"
          "uid=1000"
          "gid=1000"
          "dmask=077"
          "umask=177"
        ];
      };
    };

    swapDevices = [
      { device = "/dev/disk/by-uuid/510dd866-22e0-41e0-a2ae-254596d098b6"; }
    ];

    networking = {
      hostName = "aurora";
    };

    console = {
      font = "${pkgs.terminus_font}/share/consolefonts/ter-i16n.psf.gz";
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
