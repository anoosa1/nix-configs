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

    # nixos-hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # nix-cachyos-kernel
    nix-cachyos-kernel = {
      url = "github:xddxdd/nix-cachyos-kernel/release";

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

    # authentik-nix
    authentik-nix = {
      url = "github:nix-community/authentik-nix";

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
      url = "git+ssh://git@github.com/anoosa1/secrets.git";
      flake = false;
    };

    # apkgs
    apkgs = {
      url = "git+ssh://git.asherif.xyz:23231/apkgs.git";

      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } {
    systems = [ "x86_64-linux" ]; 
    imports = [ (inputs.import-tree ./modules) ];
  };
}
