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

      lf = {
        enable = true;

        previewer = {
          keybinding = "=";
          source = "${pkgs.ctpv}/bin/ctpv";
        };

        settings = {
          #hiddenfiles = ".*:*.aux:*.log:*.bbl:*.bcf:*.blg:*.run.xml";
          icons = true;
          ifs = "\\n";
          period = 1;
          scrolloff = 10;
          shell = "bash";
          shellopts = "-eu";
        };

        commands = {
          #on-quit = "%${pkgs.ctpv}/bin/ctpv -e $id";
          copyto = ''
            ''${{
            clear; ${pkgs.ncurses}/bin/tput cup $(($(${pkgs.ncurses}/bin/tput lines)/3)); ${pkgs.ncurses}/bin/tput bold
            set -f
            clear; echo "Copy to where?"
            dest="$(sed -e 's/\s*#.*//' -e '/^$/d' -e 's/^\S*\s*//' ${config.xdg.configHome}/bm-dirs | ${pkgs.skim}/bin/sk | sed 's|~|$HOME|')" &&
            for x in $fx; do
                    eval cp -ivr \"$x\" \"$dest\"
            done &&
            notify-send "📋 File(s) copied." "File(s) copies to $dest."
            }}
          '';
          bulkrename = ''
            ''${{
            tmpfile_old="$(${pkgs.mktemp}/bin/mktemp)"
            tmpfile_new="$(${pkgs.mktemp}/bin/mktemp)"
            [ -n "$fs" ] && fs=$(${pkgs.toybox}/bin/basename -a $fs) || fs=$(ls)
            ${pkgs.toybox}/bin/echo "$fs" > "$tmpfile_old"
            ${pkgs.toybox}/bin/echo "$fs" > "$tmpfile_new"
            $EDITOR "$tmpfile_new"
            [ "$(wc -l < "$tmpfile_old")" -eq "$(wc -l < "$tmpfile_new")" ] || { rm -f "$tmpfile_old" "$tmpfile_new"; exit 1; }
            paste "$tmpfile_old" "$tmpfile_new" | while IFS="$(printf '\t')" read -r src dst
            do
                [ "$src" = "$dst" ] || [ -e "$dst" ] || mv -- "$src" "$dst"
            done
            rm -f "$tmpfile_old" "$tmpfile_new"
            lf -remote "send $id unselect"
            }}
          '';
          delete = ''
            ''${{
            clear; ${pkgs.ncurses}/bin/tput cup $(($(${pkgs.ncurses}/bin/tput lines)/3)); ${pkgs.ncurses}/bin/tput bold
            set -f
            printf "%s\n\t" "$fx"
            printf "delete?[y/N]"
            read ans
            [ $ans = "y" ] && ${pkgs.toybox}/bin/rm -rf -- $fx
            }}
          '';
          extract = ''
            ''${{
            clear; ${pkgs.ncurses}/bin/tput cup $(($(${pkgs.ncurses}/bin/tput lines)/3)); ${pkgs.ncurses}/bin/tput bold
            set -f
            printf "%s\n\t" "$fx"
            printf "extract?[y/N]"
            read ans
            [ $ans = "y" ] && {
                    case $fx in
                            *.tar.bz2)  ${pkgs.toybox}/bin/tar xjf  $fx   ;;
                            *.tar.gz)   ${pkgs.toybox}/bin/tar xzf  $fx   ;;
                            *.bz2)      ${pkgs.toybox}/bin/buzip2   $fx   ;;
                            *.rar)      ${pkgs.unrar}/bin/unrar e   $fx   ;;
                            *.gz)       ${pkgs.gzip}/bin/gunzip     $fx   ;;
                            *.tar)      ${pkgs.toybox}/bin/tar xf   $fx   ;;
                            *.tbz2)     ${pkgs.toybox}/bin/tar xjf  $fx   ;;
                            *.tgz)      ${pkgs.toybox}/bin/tar xzf  $fx   ;;
                            *.zip)      ${pkgs.unzip}/bin/unzip     $fx   ;;
                            *.Z)        ${pkgs.gzip}/bin/uncompress $fx   ;;
                            *.7z)       ${pkgs.p7zip}/bin/7z x      $fx   ;;
                            *.tar.xz)   ${pkgs.toybox}/bin/tar xf   $fx   ;;
                    esac
            }
          '';
          mkdir = "$mkdir -p \"$(echo $* | tr ' ' '\\ ')\"";
          moveto = ''
            ''${{
            clear; ${pkgs.ncurses}/bin/tput cup $(($(${pkgs.ncurses}/bin/tput lines)/3)); ${pkgs.ncurses}/bin/tput bold
            set -f
            clear; echo "Move to where?"
            dest="$(sed -e 's/\s*#.*//' -e '/^$/d' -e 's/^\S*\s*//' $XDG_CONFIG_HOME/bm-dirs | fzf | sed 's|~|$HOME|')" &&
            for x in $fx; do
                    eval mv -iv \"$x\" \"$dest\"
            done &&
            ${pkgs.libnotify}/bin/notify-send "🚚 File(s) moved." "File(s) moved to $dest."
            }}
          '';
          open = ''
            ''${{
            case $(${pkgs.file}/bin/file --mime-type "$(${pkgs.toybox}/bin/readlink -f $f)" -b) in
                image/vnd.djvu|application/pdf|application/octet-stream|application/postscript) ${pkgs.util-linuxMinimal}/bin/setsid -f ${pkgs.zathura}/bin/zathura $fx >/dev/null 2>&1 ;;
                text/*|application/json|inode/x-empty|application/x-subrip) $EDITOR $fx;;
                image/*) rotdir.sh $f | ${pkgs.toybox}/bin/grep -i "\.\(png\|jpg\|jpeg\|gif\|webp\|avif\|tif\|ico\)\(_large\)*$" |
                        ${pkgs.util-linuxMinimal}/bin/setsid -f ${pkgs.nsxiv}/bin/nsxiv -aio 2>/dev/null | while read -r file; do
                                [ -z "$file" ] && continue
                                ${pkgs.lf}/bin/lf -remote "send select \"$file\""
                                ${pkgs.lf}/bin/lf -remote "send toggle"
                        done &
                        ;;
                audio/*|video/x-ms-asf) ${pkgs.mpv}/bin/mpv --audio-display=no $f ;;
                video/*) ${pkgs.util-linuxMinimal}/bin/setsid -f ${pkgs.mpv}/bin/mpv $f -quiet >/dev/null 2>&1 ;;
                application/pdf|application/vnd.djvu|application/epub*) ${pkgs.util-linuxMinimal}/bin/setsid -f ${pkgs.zathura}/bin/zathura $fx >/dev/null 2>&1 ;;
                application/pgp-encrypted) $EDITOR $fx ;;
                *) for f in $fx; do ${pkgs.util-linuxMinimal}/bin/setsid -f $OPENER $f >/dev/null 2>&1; done;;
            esac
            }}
          '';
          setbg = "setbg.sh $1";
        };
        keybindings = {
          "<enter>" = "shell";
          "A" = ":rename; cmd-end";
          "a" = "&xdg-open \"$f\"";
          "B" = "bulkrename";
          "b" = "$setbg.sh $f";
          "C" = "copyto";
          "c" = "push A<c-u>";
          "D" = "delete";
          "E" = "extract";
          "<c-e>" = "down";
          "<c-f>" = "$lf -remote \"send $id select \"$(${pkgs.skim}/bin/sk)\"\"";
          "g" = "top";
          "I" = ":rename; cmd-home";
          "i" = ":rename; cmd-right";
          "J" = "$lf -remote \"send $id cd $(sed -e 's/\\s*#.*//' -e '/^$/d' -e 's/^\\S*\\s*//' ${config.xdg.configHome}/bm-dirs | ${pkgs.skim}/bin/sk)\"";
          "M" = "moveto";
          "<c-n>" = "push :mkdir<space>";
          "<c-r>" = "reload";
          "<c-s>" = "set hidden!";
          "V" = "push :!nvim<space>";
          "W" = "$setsid -f $TERMINAL >/dev/null 2>&1";
          "X" = "!$f";
          "x" = "$$f";
          "Y" = "$printf \"%s\" \"$fx\" | xclip -selection clipboard";
          "<c-y>" = "up";
        };
        extraConfig = ''
          set sixel true
          source "~/.local/etc/shortcuts.d/shortcuts.lf"
          &${pkgs.ctpv}/bin/ctpv -s $id
          cmd on-quit %${pkgs.ctpv}/bin/ctpv -e $id
          set cleaner ${pkgs.ctpv}/bin/ctpvclear
        '';
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

    xdg = {
      configFile = {
        "ctpv/config" = {
          text = ''
            set chafasixel
          '';
        };

        "lf/icons" = {
          text = ''
            di 
            fi 
            tw 🤝
            ow 
            ln 
            or X
            ex 
            *.txt 
            *.mom 
            *.me 
            *.ms 
            *.png 
            *.webp 
            *.ico 
            *.jpg 
            *.jpe 
            *.jpeg 
            *.gif 
            *.svg 
            *.tif 
            *.tiff 
            *.xcf 
            *.html 
            *.xml 
            *.gpg 
            *.pgp 
            *.css 
            *.pdf 
            *.djvu 
            *.epub 
            *.csv 
            *.xlsx 
            *.tex 
            *.md 
            *.r 
            *.R 
            *.rmd 
            *.Rmd 
            *.m 
            *.mp3 
            *.opus 
            *.ogg 
            *.m4a 
            *.flac 
            *.wav 
            *.mkv 
            *.mp4 
            *.webm 
            *.mpeg 
            *.avi 
            *.mov 
            *.mpg 
            *.wmv 
            *.m4b 
            *.flv 
            *.zip 
            *.rar 
            *.7z 
            *.tar 
            *.z64 
            *.v64 
            *.n64 
            *.gba 
            *.nes 
            *.gdi 
            *.1 
            *.nfo 
            *.info 
            *.log 
            *.iso 
            *.img 
            *.bib 
            *.ged 
            *.part 
            *.torrent 
            *.jar 
            *.java 
          '';
        };
      };
    };
  };
}
