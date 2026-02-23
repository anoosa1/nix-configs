{ inputs, self, ... }: {
  flake.nixosConfigurations.apollo = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.apollo
      self.nixosModules.anas
      self.nixosModules.desktop
      self.nixosModules.nixos
      self.nixosModules.ssh
      self.nixosModules.stylix
    ];
  };

  flake.nixosModules.apollo = { pkgs, ... }: {
    boot = {
      kernelPackages = pkgs.linuxPackages_latest;
      kernelModules = [ "kvm-intel" ];
      extraModulePackages = [ ];

      initrd = {
        availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
        kernelModules = [ ];
      };
    };

    fileSystems = {
      "/" = {
        device = "/dev/disk/by-uuid/5a64d9bc-5366-4032-8cee-8e35ef347e67";
        fsType = "ext4";
      };

      "/boot" = {
        device = "/dev/disk/by-uuid/B92E-64CC";
        fsType = "vfat";
        options = [ "fmask=0077" "dmask=0077" ];
      };
    };

    swapDevices = [
      { device = "/dev/disk/by-uuid/98ab2804-64e6-4a71-afec-4d9a69310470"; }
    ];

    networking = {
      hostName = "apollo";
    };

    console = {
      font = "${pkgs.terminus_font}/share/consolefonts/ter-i32n.psf.gz";
    };

    hardware = {
      cpu.intel.updateMicrocode = true;

      # bluetooth
      bluetooth = {
        enable = true;
        powerOnBoot = true;
      };
    };
  };
}
