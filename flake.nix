{
  description = "Flake for my home-manager and computer configurations";

  inputs = {
    # Nixpkgs
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager/master";

      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };

    nix-cachyos-kernel = {
      url = "github:xddxdd/nix-cachyos-kernel/release";

      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };

    # NixOS Hardware
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };

    # Sops nix
    sops-nix = {
      url = "github:Mic92/sops-nix";

      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };

    # Niri
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };

    # Stylix
    stylix = {
      url = "github:danth/stylix";
    };

    ## Personal flakes
    # Secrets
    secrets = {
      url = "git+ssh://git@github.com/anoosa1/secrets.git";
      flake = false;
    };

    # apkgs
    apkgs = {
      url = "git+ssh://git@github.com/anoosa1/apkgs.git";
    };

    nix-minecraft = {
      url = "github:Infinidoge/nix-minecraft";
    };
  };

  outputs = {nixpkgs, ...} @ inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    nixosConfigurations = {
      aurora = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};

        modules = [
          inputs.niri.nixosModules.niri
          inputs.sops-nix.nixosModules.sops
          ./hosts/aurora
          ./nixos
          ./users
        ];
      };

      apollo = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};

        modules = [
          inputs.niri.nixosModules.niri
          inputs.sops-nix.nixosModules.sops
          ./hosts/apollo
          ./nixos
          ./users
        ];
      };

      astra = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};

        modules = [
          inputs.niri.nixosModules.niri
          inputs.sops-nix.nixosModules.sops
          ./hosts/astra
          ./nixos
          ./nixos/services
          ./users
        ];
      };
    };
  };
}
