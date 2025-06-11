{
  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      autocd = true;
      dotDir = ".local/etc/zsh";

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
  };
}
