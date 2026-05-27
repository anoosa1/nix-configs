{
  description = "Flake for my home-manager and computer configurations";

  inputs = {
    # nixpkgs
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    # import-tree
    import-tree = {
      url = "github:vic/import-tree";
    };

    # nvf
    nvf = {
      url = "github:notashelf/nvf";
    };

    # hermes
    hermes-agent = {
      url = "git+https://git.asherif.xyz/anoosa/hermes-agent";

      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };

    # quickshell
    quickshell = {
      url = "git+https://git.outfoxxed.me/quickshell/quickshell";

      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };

    # dms
    dms = {
      url = "github:AvengeMedia/DankMaterialShell";

      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };

    # wrappers
    wrappers = {
      url = "github:BirdeeHub/nix-wrapper-modules";
    
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };

    # disko
    disko = {
      url = "github:nix-community/disko";

      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };

    # impermanence
    impermanence = {
      url = "github:nix-community/impermanence";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };

        home-manager = {
          follows = "home-manager";
        };
      };
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

    # rust-overlay
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # stylix
    stylix = {
      url = "github:danth/stylix";
    };

    # nix-minecraft
    nix-minecraft = {
      url = "github:Infinidoge/nix-minecraft";
    };

    # soosa
    soosa = {
      url = "ssh://gitea@git.asherif.xyz/anoosa/soosa?ref=v2.0.0";

      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };

        flake-parts = {
          follows = "flake-parts";
        };
      };
    };

    ## Personal flakes
    # Secrets
    secrets = {
      url = "git+ssh://gitea@git.asherif.xyz/anoosa/secrets.git";
      flake = false;
    };
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } {
    perSystem = { pkgs, system, ... }: {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [
          inputs.rust-overlay.overlays.default
        ];
        config.allowUnfree = true;
      };

      wrappers.pkgs = pkgs; # choose a different `pkgs`
      wrappers.control_type = "exclude"; # | "build" (default: "exclude")
    };
    systems = inputs.nixpkgs.lib.platforms.all;
    imports = [ inputs.wrappers.flakeModules.wrappers (inputs.import-tree ./modules) ];
  };
}
