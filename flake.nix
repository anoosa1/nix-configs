{
  description = "Flake for my home-manager and computer configurations";

  inputs = {
    # nixpkgs
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    import-tree = {
      url = "github:vic/import-tree";
    };

    nvf = {
      url = "github:notashelf/nvf";
    };

    # flake-parts
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };

    # home-manager
    home-manager = {
      url = "github:nix-community/home-manager/master";

      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };

    # sops-nix
    sops-nix = {
      url = "github:Mic92/sops-nix";

      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };

    # niri
    niri = {
      url = "github:sodiboo/niri-flake";

      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };

    # stylix
    stylix = {
      url = "github:danth/stylix";
    };

    # nix-minecraft
    nix-minecraft = {
      url = "github:Infinidoge/nix-minecraft";
    };

    ## Personal flakes
    # Secrets
    secrets = {
      url = "git+ssh://gitea@git.asherif.xyz/anoosa/secrets.git";
      flake = false;
    };
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } {
    systems = [ "x86_64-linux" ]; 
    imports = [ (inputs.import-tree ./modules) ];
  };
}
