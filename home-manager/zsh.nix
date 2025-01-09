{ config, pkgs, ... }:

{
  programs = {
     zsh = {
       enable = true;
       autosuggestion = {
         enable = true;
       };
       enableCompletion = true;
       autocd = true;
       completionInit = ''
         autoload -U compinit
	 zstyle ':completion:*' menu select
	 zmodload zsh/complist
	 compinit
	 _comp_options+=(globdots)
       '';
       #dirHashs = {
       #};
       dotDir = ".local/etc/zsh";
       #envExtra = {
       #};
       history = {
         extended = true;
         path = "$XDG_STATE_HOME/zsh/history";
         save = 100000000000000000;
	 share = true;
         size = 100000000000000000;
       };
       initExtra = ''
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
         preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

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
       #initExtraBeforeCompInit = ''
       #'';
       initExtraFirst = ''
         umask 077
         autoload -U colors && colors
         stty stop undef
	 setopt interactive_comments
	 [ -f "$XDG_CONFIG_HOME/shortcuts.d/shortcuts.zsh" ] && source "$XDG_CONFIG_HOME/shortcuts.d/shortcuts.zsh"
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
       plugins = [
         {
	   name = "zsh-fast-syntax-highlighting";
	   src = pkgs.zsh-fast-syntax-highlighting;
	   file = "share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh";
	 }
         #{
	 #  name = "zsh-autosuggestions";
	 #  src = pkgs.zsh-autosuggestions;
	 #  file = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
	 #}
       ];
       profileExtra = ''
         [ -f "$XDG_CONFIG_HOME/profile" ] && source "$XDG_CONFIG_HOME/profile"
       '';
       #globalAliases = {
       #};

       shellAliases = {
         # doas not required for these commands
         mount = "sudo mount";
         umount = "sudo umount";
         pacman = "sudo pacman";
         updatedb = "sudo updatedb";

         # Verbosity and settings that you pretty much just always are going to want.
         cp = "cp -iv";
         mv = "mv -iv";
         rm = "rm -vI";
         rsync = "rsync -vrPlu";
         mkd = "mkdir -pv";
         yt = "yt-dlp --embed-metadata -i";
         yta = "yt -x -f bestaudio/best";
         ytt = "yt --skip-download --write-thumbnail";
         ffmpeg = "ffmpeg -hide_banner";

         # Colorize commands when possible.
         ls = "eza -a --icons --color=always --group-directories-first";
         ll = "eza -lahHmgb --icons --color=always --group-directories-first";
         lt = "eza -aT --icons --color=always --group-directories-first";
         grep = "grep --color=auto";
         diff = "diff --color=auto";
         ccat = "highlight --out-format=ansi";
         ip = "ip -color=auto";

         # These common commands are just too long! Abbreviate them.
         ka = "killall";
         g = "git";
         ga = "git push";
         gp = "git add -A";
         gc = "git commit";
         trem = "transmission-remote";
         YT = "youtube-viewer";
         sdn = "shutdown -h now";
         e = "nvim";
         d = "pacman -Rcnsuv";
         i = "pacman -S";
         p = "paru";
         pi = "paru -S --removemake";
         c = "cargo";
         ci = "cargo install";
         cu = "cargo uninstall";
         xi = "xbps-install";
         xr = "xbps-remove -R";
         xq = "xbps-query";
         z = "zathura";
         mi = "make clean install";
         mu = "make clean uninstall";
         dmu = "doas make clean uninstall";
         dmi = "doas make clean install";
         s = "systemctl";
         j = "journalctl";
	 "..." = "cd ../..";
	 "...." = "cd ../../..";

         magit = "nvim -c MagitOnly";
         weath = "less -S $XDG_CACHE_HOME/weatherreport";
         flatkill = "flatpak kill";

         se = "se.sh";
         fzf = "sk";
         sw = "$XDG_CONFIG_HOME/winit/winitrc";

         abook = "abook -C .local/etc/abook/abook.conf -f .local/share/abook/addressook";
         sx = "sx $XINITRC";
         mbsync = "mbsync -c $MBSYNCRC";

         astra = "ssh astra";
       };
     };
  };
}
