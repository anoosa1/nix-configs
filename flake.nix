{

  description = "PC configuration";

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

    # Neovim
    nixvim = {
      url = "github:anoosa1/nvim-flake/main";
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

    # Stylix
    stylix = {
      url = "github:danth/stylix";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs:

  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in

  {
    nixosConfigurations = {
      aurora = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };

        modules = [
          inputs.stylix.nixosModules.stylix
          ./nixos/stylix
          ./hosts/aurora
	  ./nixos
        ];
      };
      apollo = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };

        modules = [
          inputs.stylix.nixosModules.stylix
          ./nixos/stylix
	  ./hosts/apollo
          ./nixos
        ];
      };
      astra = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };

        modules = [
          inputs.sops-nix.nixosModules.sops
          ./hosts/astra
	  ./nixos
        ];
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      "anas" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home-manager/home.nix
          inputs.stylix.homeManagerModules.stylix
        ];
      };
    };
  };
}
