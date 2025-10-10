{
  lib,
  pkgs,
  config,
  ...
}:
{
  options.anoosa.lf.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable lf";
    example = true;
  };

  config = lib.mkIf config.anoosa.lf.enable {
    home.packages = with pkgs; [
      ctpv
    ];

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

    programs = {
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
                image/svg+xml) ${pkgs.imagemagick_light}/bin/display -- $f ;;
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
    };
  };
}
