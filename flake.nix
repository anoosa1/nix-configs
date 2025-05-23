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

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };

    secrets = {
      url = "git+ssh://git@github.com/anoosa1/secrets.git";
      flake = false;
    };

    apkgs = {
      url = "git+ssh://git@github.com/anoosa1/apkgs.git";
    };

    # Stylix
    stylix = {
      url = "github:danth/stylix";
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
          ./hosts/aurora
          ./nixos
          ./users
        ];
      };

      apollo = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};

        modules = [
          inputs.nixos-hardware.nixosModules.apple-macbook-pro-11-1
          ./hosts/apollo
          ./nixos
        ];
      };

      astra = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};

        modules = [
          inputs.sops-nix.nixosModules.sops
          ./hosts/astra
          ./nixos
          ./users
        ];
      };
    };
  };
}
