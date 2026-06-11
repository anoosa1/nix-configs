{
  self,
  inputs,
  ...
}:
{
  flake.nixosModules.nixos = { lib, pkgs, ... }: {
    ## nixpkgs
    nixpkgs = {
      hostPlatform = lib.mkDefault "x86_64-linux";
  
      config = {
        # allow unfree packages
        allowUnfree = true;
  
        permittedInsecurePackages = [
          "broadcom-sta-6.30.223.271-59-6.12.69"
        ];
      };
    };

    # time
    time = {
      # timezone
      timeZone = "America/Toronto";
      hardwareClockInLocalTime = true;
    };
  
    # Select internationalisation properties.
    i18n = {
      defaultLocale = "en_US.UTF-8";
    };

    fonts = {
      packages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.comic-code
        pkgs.noto-fonts
        pkgs.noto-fonts-cjk-sans
        pkgs.noto-fonts-color-emoji
      ];
    };
    
    console = {
      enable = true;
      packages = with pkgs; [ terminus_font ];
      keyMap = "us";

      colors = [
        "1e1e2e"
        "f38ba8"
        "a6e3a1"
        "f9e2af"
        "89b4fa"
        "f5c2e7"
        "94e2d5"
        "bac2de"
        "585b70"
        "f38ba8"
        "a6e3a1"
        "f9e2af"
        "89b4fa"
        "f5c2e7"
        "94e2d5"
        "a6adc8"
      ];
    };
  
    ## hardware
    hardware = {
      enableAllFirmware = true;

      graphics = {
        enable = true;
      };
    };
  
    programs = {
      starship = {
        enable = true;
        interactiveOnly = true;

        settings = {
          add_newline = false;
          format = lib.concatStrings [
            #"$username"
            "$hostname"
            "$localip"
            "$shlvl"
            "$singularity"
            "$kubernetes"
            "$directory"
            "$vcsh"
            "$fossil_branch"
            "$git_branch"
            "$git_commit"
            "$git_state"
            "$git_metrics"
            "$git_status"
            "$hg_branch"
            "$pijul_channel"
            "$docker_context"
            "$package"
            "$c"
            "$cmake"
            "$cobol"
            "$daml"
            "$dart"
            "$deno"
            "$dotnet"
            "$elixir"
            "$elm"
            "$erlang"
            "$fennel"
            "$golang"
            "$guix_shell"
            "$haskell"
            "$haxe"
            "$helm"
            "$java"
            "$julia"
            "$kotlin"
            "$gradle"
            "$lua"
            "$nim"
            "$nodejs"
            "$ocaml"
            "$opa"
            "$perl"
            "$php"
            "$pulumi"
            "$purescript"
            "$python"
            "$raku"
            "$rlang"
            "$red"
            "$ruby"
            "$rust"
            "$scala"
            "$solidity"
            "$swift"
            "$terraform"
            "$vlang"
            "$vagrant"
            "$zig"
            "$buf"
            "$nix_shell"
            "$conda"
            "$meson"
            "$spack"
            "$memory_usage"
            "$aws"
            "$gcloud"
            "$openstack"
            "$azure"
            "$env_var"
            "$crystal"
            "$custom"
            "$sudo"
            "$cmd_duration"
            "$jobs"
            "$battery"
            "$time"
            "$status"
            "$os"
            "$container"
            "$shell"
            "$character"
          ];

          username = {
            style_user = "fg:green bold";
            style_root = "fg:red bold";
            format = "[$user]($style)";
            disabled = false;
            show_always = true;
          };

          hostname = {
            ssh_only = false;
            format = "[$hostname](fg:yellow bold) ";
            #format = "[@](fg:grey bold) [$hostname](fg:yellow bold) ";
            trim_at = ".";
            disabled = false;
          };

          character = {
            format = "$symbol ";
            success_symbol = "[i >](fg:green bold)";
            error_symbol = "[i ✗](fg:red bold)";
            vimcmd_symbol = "[n <](fg:yellow bold)";
            vimcmd_replace_one_symbol = "[r <](fg:magenta bold)";
            vimcmd_replace_symbol = "[r <](fg:magenta bold)";
            vimcmd_visual_symbol = "[v <](fg:yellow bold)";
            disabled = false;
          };

          directory = {
            read_only = "";
            truncation_length = 10;
            truncate_to_repo = true;
            style = "fg:blue bold italic";
          };

          cmd_duration = {
            min_time = 4;
            show_milliseconds = false;
            disabled = false;
            style = "fg:#F2777A bold italic";
          };

          conda = {
            symbol = "";
          };

          dart = {
            symbol = "";
          };

          git_branch = {
            symbol = "";
          };

          git_state = {
            style = "fg:#F2777A bold";
            format = "[$state( $progress_current/$progress_total) ]($style)";
            rebase = "rebase";
            merge = "merge";
            revert = "revert";
            cherry_pick = "cherry";
            bisect = "bisect";
            am = "am";
            am_or_rebase = "am/rebase";
          };

          golang = {
            symbol = "";
          };

          java = {
            symbol = "";
          };

          memory_usage = {
            symbol = "";
          };

          nix_shell = {
            symbol = "";
          };

          package = {
            symbol = "";
          };

          rust = {
            symbol = "";
          };
        };
      };

      # zsh
      zsh = {
        enable = true;
      };
    };
  
    system = {
      stateVersion = "24.11";
    };
  
    ## environment
    environment = {
      pathsToLink = ["/share/applications" "/share/xdg-desktop-portal"];
    
      # variables
      sessionVariables = rec {
        XDG_BIN_HOME = "$HOME/.local/bin";
        XDG_CACHE_HOME = "$HOME/.local/var/cache";
        XDG_CONFIG_HOME = "$HOME/.local/etc";
        XDG_DATA_HOME = "$HOME/.local/share";
        XDG_STATE_HOME = "$HOME/.local/var/state";
        ZDOTDIR = "$XDG_CONFIG_HOME/zsh";
  
        PATH = [
          "${XDG_BIN_HOME}"
        ];
      };
  
      # system packages
      systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.antigravity-cli
        self.packages.${pkgs.stdenv.hostPlatform.system}.comic-code
        self.packages.${pkgs.stdenv.hostPlatform.system}.kitty
        self.packages.${pkgs.stdenv.hostPlatform.system}.neovim
        self.packages.${pkgs.stdenv.hostPlatform.system}.tmux
        self.packages.${pkgs.stdenv.hostPlatform.system}.yazi
        pkgs.opencode
        pkgs.git
        pkgs.fastfetch
        pkgs.ffmpeg
        pkgs.linux-firmware
        pkgs.sops
        pkgs.strongswan
      ];
    };
  
    ## nix
    nix = {
      enable = true;
  
      settings = {
        experimental-features = ["nix-command" "flakes"];
        auto-optimise-store = true;
        substituters = [
          "https://cache.nixos.org"
          "https://attic.xuyh0120.win/lantian"
        ];
  
        trusted-public-keys = [
          "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
        ];
      };
  
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };
    };
  
    ## security
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
  
    ## services
    services = {
      # dbus
      dbus = {
        enable = true;
        implementation = "broker";
      };
  
      # kmscon
      kmscon = {
        enable = true;

        config = {
          hwaccel = true;
          font-size = "24";
          font-name = "Comic Code";
          palette = "custom";
          palette-black = "30,30,46";
          palette-red = "243,139,168";
          palette-green = "166,227,161";
          palette-yellow = "249,226,175";
          palette-blue = "137,180,250";
          palette-magenta = "245,194,231";
          palette-cyan = "148,226,213";
          palette-light-grey = "186,194,222";
          palette-dark-grey = "88,91,112";
          palette-light-red = "243,139,168";
          palette-light-green = "166,227,161";
          palette-light-yellow = "249,226,175";
          palette-light-blue = "137,180,250";
          palette-light-magenta = "245,194,231";
          palette-light-cyan = "148,226,213";
          palette-white = "166,173,200";
          palette-foreground = "186,194,222";
          palette-background = "30,30,46";
        };
      };
  
      resolved = {
        enable = true;
      };

      tailscale = {
        enable = true;
        useRoutingFeatures = "both";
      };
    };
    
    users = {
      defaultUserShell = pkgs.zsh;
    };
  };
}
