{
  inputs,
  lib,
  self,
  ...
}:
{
  imports = [
    inputs.home-manager.flakeModules.home-manager
  ];

  flake.homeModules.home = { config, pkgs, ...}: {
    home = {
      stateVersion = "24.11";

      packages = [
        pkgs.ctpv
        self.packages.${pkgs.system}.handler
      ];
    };

    programs = {
      direnv = {
        enable = true;
        enableZshIntegration = true;
        silent = true;

        config = {
          global = {
            disable_stdin = true;
          };

          whitelist = {
            prefex = [
              "/home/anas/docs/code"
            ];
          };
        };

        nix-direnv = {
          enable = true;
        };

        #stdlib = ''
        #'';
      };

      newsboat = {
        enable = true;
        autoReload = true;

        extraConfig = ''
          urls-source "ocnews"
          ocnews-url "https://hub.asherif.xyz"
          ocnews-login "anas"
          ocnews-passwordeval "pa.sh s newsboat"

          #show-read-feeds no
          #external-url-viewer "urlscan -dc -r 'handler.sh {}'"
          browser "handler.sh --menu"
          
          bind-key j down
          bind-key k up
          bind-key j next articlelist
          bind-key k prev articlelist
          bind-key J next-feed articlelist
          bind-key K prev-feed articlelist
          bind-key G end
          bind-key g home
          bind-key d pagedown
          bind-key u pageup
          bind-key l open
          bind-key h quit
          bind-key a toggle-article-read
          bind-key n next-unread
          bind-key N prev-unread
          bind-key D pb-download
          bind-key U show-urls
          bind-key x pb-delete
          
          color listnormal cyan default
          color listfocus black yellow standout bold
          color listnormal_unread blue default
          color listfocus_unread yellow default bold
          color info red black bold
          color article white default bold
          
          macro , open-in-browser
          macro t set browser "handler.sh --qndl" ; open-in-browser ; set browser handler.sh
          macro a set browser "tsp yt-dlp --embed-metadata -xic -f bestaudio/best --restrict-filenames" ; open-in-browser ; set browser handler.sh
          macro v set browser "setsid -f mpv" ; open-in-browser ; set browser handler.sh
          macro w set browser "elinks" ; open-in-browser ; set browser handler.sh
          macro d set browser "handler.sh --menu" ; open-in-browser ; set browser handler.sh
          macro c set browser "echo %u | xclip -r -sel c" ; open-in-browser ; set browser handler.sh
          macro C set browser "youtube-viewer --comments=%u" ; open-in-browser ; set browser handler.sh
          macro p set browser "peertubetorrent %u 1080" ; open-in-browser ; set browser handler.sh
          
          highlight all "---.*---" yellow
          highlight feedlist ".*(0/0))" black
          highlight article "(^Feed:.*|^Title:.*|^Author:.*)" cyan default bold
          highlight article "(^Link:.*|^Date:.*)" default default
          highlight article "https?://[^ ]+" green default
          highlight article "^(Title):.*$" blue default
          highlight article "\\[[0-9][0-9]*\\]" magenta default bold
          highlight article "\\[image\\ [0-9]+\\]" green default bold
          highlight article "\\[embedded flash: [0-9][0-9]*\\]" green default bold
          highlight article ":.*\\(link\\)$" cyan default
          highlight article ":.*\\(image\\)$" blue default
          highlight article ":.*\\(embedded flash\\)$" magenta default
        '';
      };

      git = {
        enable = true;

        settings = {
          aliases = {
            co = "checkout";
            c = "commit -a";
            a = "add -A";
            p = "push";
          };

          user = {
            name = "Anas";
            email = "anas@asherif.xyz";
          };
        };

        signing = {
          format = "ssh";
          signByDefault = true;
          key = "~/.local/etc/ssh/id_ed25519.pub";
        };

        lfs = {
          enable = true;
        };
      };

      gpg = {
        enable = true;
        homedir = "${config.xdg.dataHome}/gnupg";
      };

      skim = {
        enable = true;
        enableZshIntegration = true;
        changeDirWidgetCommand = "fd --type d";
        fileWidgetCommand = "fd --type f";

        defaultOptions = [
          "--prompt >"
          "--height 15"
        ];
      };

      starship = {
        enable = true;
        enableZshIntegration = true;

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

      zoxide = {
        enable = true;
        enableZshIntegration = true;

        options = [
          "--cmd cd"
        ];
      };

      zsh = {
        enable = true;
        enableCompletion = true;
        autocd = true;
        dotDir = "${config.xdg.configHome}/zsh";

        autosuggestion = {
          enable = true;
        };

        syntaxHighlighting = {
          enable = true;

          highlighters = [
            "main"
            "brackets"
          ];
        };

        completionInit = ''
          autoload -U compinit
          zstyle ':completion:*' menu select
          zmodload zsh/complist
          compinit
          _comp_options+=(globdots)
        '';

        #dirHashs = {
        #};

        #envExtra = {
        #};

        history = {
          extended = true;
          path = "$XDG_STATE_HOME/zsh/history";
          save = 100000000000000000;
          share = true;
          size = 100000000000000000;
        };

        initContent = ''
          umask 077
          autoload -U colors && colors
          stty stop undef
          setopt interactive_comments
          [ -f "$XDG_CONFIG_HOME/shortcuts.d/shortcuts.zsh" ] && source "$XDG_CONFIG_HOME/shortcuts.d/shortcuts.zsh"
          # vi mode
          bindkey -v

          # Use vim keys in tab complete menu:
          bindkey -M menuselect 'h' vi-backward-char
          bindkey -M menuselect 'k' vi-up-line-or-history
          bindkey -M menuselect 'l' vi-forward-char
          bindkey -M menuselect 'j' vi-down-line-or-history
          bindkey -v '^?' backward-delete-char

          # Change cursor shape for different vi modes.
          function zle-keymap-select () {
              case $KEYMAP in
                  vicmd) echo -ne '\e[1 q';;      # block
                  viins|main) echo -ne '\e[5 q';; # beam
              esac
          }

          function chpwd() {
              emulate -L zsh
              ls
          }

          zle -N zle-keymap-select
          zle-line-init() {
              zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
              echo -ne "\e[5 q"
          }
          zle -N zle-line-init
          echo -ne '\e[5 q' # Use beam shape cursor on startup.
          preexec() { echo -ne '\e[5 q' ;}
          lfcd () { cd "$(command lf -print-last-dir "$@")" }
          bindkey -s '^o' '^ulfcd\n'

          bindkey -s '^a' '^ueva\n'

          bindkey -s '^f' '^ucd "$(fd --type=directory | sk)"\n'

          bindkey '^[[P' delete-char

          # Edit line in nvim with ctrl-e:
          autoload edit-command-line; zle -N edit-command-line
          bindkey '^e' edit-command-line
          bindkey -M vicmd '^[[P' vi-delete-char
          bindkey -M vicmd '^e' edit-command-line
          bindkey -M visual '^[[P' vi-delete
        '';

        localVariables = {
          KEYTIMEOUT = "1";
        };

        loginExtra = ''
          [ -f "$XDG_CONFIG_HOME/login" ] && source "$XDG_CONFIG_HOME/login"
        '';

        logoutExtra = ''
          [ -f "$XDG_CONFIG_HOME/logout" ] && source "$XDG_CONFIG_HOME/logout"
        '';

        profileExtra = ''
          [ -f "$XDG_CONFIG_HOME/profile" ] && source "$XDG_CONFIG_HOME/profile"
        '';
      };

      tmux = {
        enable = true;
        baseIndex = 1;
        clock24 = true;
        focusEvents = true;
        historyLimit = 5000;
        keyMode = "vi";
        mouse = true;
        #sensibleOnTop = true;
        shortcut = "Space";
        terminal = "screen-256color";

        extraConfig = ''
          set -g allow-passthrough on
        '';
      };
    };
    
    services = {
      gpg-agent = {
        enable = true;
        enableZshIntegration = true;
        defaultCacheTtl = 54000;
        maxCacheTtl = 54000;

        extraConfig = ''
          allow-preset-passphrase
        '';
      };
    };
  };
}
