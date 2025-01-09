# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).
{
  inputs,
  lib,
  config,
  pkgs,
  outputs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/virtualisation/proxmox-lxc.nix")
    inputs.sops-nix.nixosModules.sops
    ../services
  ];

  sops = {
    defaultSopsFile = ../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age = {
      keyFile = "/home/anas/.local/etc/sops/age/keys.txt";
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    #registry = lib.mapAttrs (_: value: {flake = value;}) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    #nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = true;
    };
  };

  networking = {
    hostName = "astra";
  };

  # Set your time zone.
  time = {
    timeZone = "America/Toronto";
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  environment.sessionVariables = rec {
    XDG_CACHE_HOME = "$HOME/.local/var/cache";
    XDG_CONFIG_HOME = "$HOME/.local/etc";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/var/state";
    ZDOTDIR = "$XDG_CONFIG_HOME/zsh";

    XDG_BIN_HOME = "$HOME/.local/bin";
    PATH = [
      "${XDG_BIN_HOME}"
    ];
  };

  services = {
    # nfs
    #nfs = {
    #  server = {
    #    enable = true;
    #  };
    #};

    # smb
    #samba = {
    #  enable = true;
    #  openFirewall = true;
    #  settings = {
    #    default = {
    #      "workgroup" = "WORKGROUP";
    #      "server string" = "aurora";
    #      "netbios name" = "aurora";
    #      "security" = "user";
    #      #"use sendfile" = "yes";
    #      #"max protocol" = "smb2";
    #      #"hosts allow" = "10.0.0.138 127.0.0.1 localhost";
    #      #"hosts deny" = "0.0.0.0/0";
    #      #"guest account" = "nobody";
    #      "map to guest" = "bad user";
    #    };
    #    #public = {
    #    #  path = "/mnt/Shares/Public";
    #    #  browseable = "yes";
    #    #  "read only" = "no";
    #    #  "guest ok" = "yes";
    #    #  "create mask" = "0644";
    #    #  "directory mask" = "0755";
    #    #  "force user" = "username";
    #    #  "force group" = "groupname";
    #    #};
    #    #private = {
    #    #  path = "/export/aa";
    #    #  browseable = "yes";
    #    #  "read only" = "no";
    #    #  "guest ok" = "no";
    #    #  "create mask" = "0600";
    #    #  "directory mask" = "0700";
    #    #  "force user" = "anas";
    #    #  "force group" = "anas";
    #    #};
    #  };
    #};
  };

  nixpkgs = {
    config = {
      # allow unfree packages
      allowUnfree = true;
    };
  };

  # system packages
  environment = {
    systemPackages = 
      (with pkgs; [
        file
        git
        inputs.nixvim.packages.${system}.default
        config.services.nextcloud.occ
        starship
        zsh
      ]);
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;

  programs = {
  };

  # security settings
  security = {
    pam = {
      services = {
        su = {
          requireWheel = true;
        };
        system-login = {
          failDelay = {
            enable = true;
            delay = 4000000;
          };
        };
      };
    };
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    # require public key authentication for better security
    #settings = {
    #  PasswordAuthentication = false;
    #  KbdInteractiveAuthentication = false;
    #  PermitRootLogin = "no";
    #};
  };
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking = {
    firewall = {
      enable = false;
      allowedTCPPorts = [2049];
      allowPing = true;
    };
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  #system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
