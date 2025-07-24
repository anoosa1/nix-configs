{
  lib,
  config,
  ...
}:
{
  options.anoosa.neomutt.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable neomutt";
    example = true;
  };

  config = lib.mkIf config.anoosa.neomutt.enable {
    programs = {
      neomutt = {
        enable = true;
        sort = "reverse-date";
        unmailboxes = true;

        sidebar = {
          enable = true;
          width = 20;
          shortPath = true;
          format = "%D%?F? [%F]?%* %?N?%N/? %?S?%S?";
        };

        extraConfig = ''
          set mail_check_stats
          set send_charset="us-ascii:utf-8"
          set mime_type_query_command = "nix run nixpkgs#file --mime-type -b %s"
          set date_format="%y/%m/%d %I:%M%p"
          set index_format="%2C %Z %?X?A& ? %D %-15.15F %s (%-4.4c)"
          set query_command = "abook --mutt-query '%s'"
          set rfc2047_parameters = yes
          set sleep_time = 0
          set markers = no
          set mark_old = no
          set mime_forward = no
          set forward_attachments = yes	# attachments are forwarded with mail
          set wait_key = no		# mutt won't ask "press key to continue"
          set fast_reply			# skip to compose when replying
          set fcc_attach			# save attachments with the body
          set forward_format = "Fwd: %s"	# format of subject when forwarding
          set forward_quote		# include message in forwards
          set reverse_name		# reply as whomever it was to
          set include			# include message in replies
          auto_view text/html		# automatically show html (mailcap uses lynx)
          auto_view application/pgp-encrypted
          alternative_order text/plain text/enriched text/html

          # Default index colors:
          color index yellow default '.*'
          color index_author red default '.*'
          color index_number blue default
          color index_subject cyan default '.*'
          
          # New mail is boldened:
          color index brightyellow black "~N"
          color index_author brightred black "~N"
          color index_subject brightcyan black "~N"
          
          # Tagged mail is highlighted:
          color index brightyellow blue "~T"
          color index_author brightred blue "~T"
          color index_subject brightcyan blue "~T"
          
          # Flagged mail is highlighted:
          color index brightgreen default "~F"
          color index_subject brightgreen default "~F"
          color index_author brightgreen default "~F"
          
          # Other colors and aesthetic settings:
          mono bold bold
          mono underline underline
          mono indicator reverse
          mono error bold
          color normal default default
          color indicator brightblack white
          color sidebar_highlight red default
          color sidebar_divider brightblack black
          color sidebar_flagged red black
          color sidebar_new green black
          color error red default
          color tilde black default
          color message cyan default
          color markers red white
          color attachment white default
          color search brightmagenta default
          color status brightyellow black
          color hdrdefault brightgreen default
          color quoted green default
          color quoted1 blue default
          color quoted2 cyan default
          color quoted3 yellow default
          color quoted4 red default
          color quoted5 brightred default
          color signature brightgreen default
          color bold black default
          color underline black default
          
          # Regex highlighting:
          color header brightmagenta default "^From"
          color header brightcyan default "^Subject"
          color header brightwhite default "^(CC|BCC)"
          color header blue default ".*"
          color body brightred default "[\-\.+_a-zA-Z0-9]+@[\-\.a-zA-Z0-9]+" # Email addresses
          color body brightblue default "(https?|ftp)://[\-\.,/%~_:?&=\#a-zA-Z0-9]+" # URL
          color body green default "\`[^\`]*\`" # Green text between ` and `
          color body brightblue default "^# \.*" # Headings as bold blue
          color body brightcyan default "^## \.*" # Subheadings as bold cyan
          color body brightgreen default "^### \.*" # Subsubheadings as bold green
          color body yellow default "^(\t| )*(-|\\*) \.*" # List items as yellow
          color body brightcyan default "[;:][-o][)/(|]" # emoticons
          color body brightcyan default "[;:][)(|]" # emoticons
          color body brightcyan default "[ ][*][^*]*[*][ ]?" # more emoticon?
          color body brightcyan default "[ ]?[*][^*]*[*][ ]" # more emoticon?
          color body red default "(BAD signature)"
          color body cyan default "(Good signature)"
          color body brightblack default "^gpg: Good signature .*"
          color body brightyellow default "^gpg: "
          color body brightyellow red "^gpg: BAD signature from.*"
          mono body bold "^gpg: Good signature"
          mono body bold "^gpg: BAD signature from.*"
          color body red default "([a-z][a-z0-9+-]*://(((([a-z0-9_.!~*'();:&=+$,-]|%[0-9a-f][0-9a-f])*@)?((([a-z0-9]([a-z0-9-]*[a-z0-9])?)\\.)*([a-z]([a-z0-9-]*[a-z0-9])?)\\.?|[0-9]+\\.[0-9]+\\.[0-9]+\\.[0-9]+)(:[0-9]+)?)|([a-z0-9_.!~*'()$,;:@&=+-]|%[0-9a-f][0-9a-f])+)(/([a-z0-9_.!~*'():@&=+$,-]|%[0-9a-f][0-9a-f])*(;([a-z0-9_.!~*'():@&=+$,-]|%[0-9a-f][0-9a-f])*)*(/([a-z0-9_.!~*'():@&=+$,-]|%[0-9a-f][0-9a-f])*(;([a-z0-9_.!~*'():@&=+$,-]|%[0-9a-f][0-9a-f])*)*)*)?(\\?([a-z0-9_.!~*'();/?:@&=+$,-]|%[0-9a-f][0-9a-f])*)?(#([a-z0-9_.!~*'();/?:@&=+$,-]|%[0-9a-f][0-9a-f])*)?|(www|ftp)\\.(([a-z0-9]([a-z0-9-]*[a-z0-9])?)\\.)*([a-z]([a-z0-9-]*[a-z0-9])?)\\.?(:[0-9]+)?(/([-a-z0-9_.!~*'():@&=+$,]|%[0-9a-f][0-9a-f])*(;([-a-z0-9_.!~*'():@&=+$,]|%[0-9a-f][0-9a-f])*)*(/([-a-z0-9_.!~*'():@&=+$,]|%[0-9a-f][0-9a-f])*(;([-a-z0-9_.!~*'():@&=+$,]|%[0-9a-f][0-9a-f])*)*)*)?(\\?([-a-z0-9_.!~*'();/?:@&=+$,]|%[0-9a-f][0-9a-f])*)?(#([-a-z0-9_.!~*'();/?:@&=+$,]|%[0-9a-f][0-9a-f])*)?)[^].,:;!)? \t\r\n<>\"]"
        '';

        binds = [
          {
            action = "noop";
            key = "i";
            
            map = [
              "index"
              "pager"
            ];
          }
          {
            action = "noop";
            key = "g";
            
            map = [
              "index"
              "pager"
            ];
          }
          {
            action = "noop";
            key = "\\Cf";
            
            map = [
              "index"
            ];
          }
          {
            action = "noop";
            key = "M";
            
            map = [
              "index"
              "pager"
            ];
          }
          {
            action = "noop";
            key = "C";
            
            map = [
              "index"
              "pager"
            ];
          }
          {
            action = "first-entry";
            key = "gg";
            
            map = [
              "index"
            ];
          }
          {
            action = "next-entry";
            key = "j";
            
            map = [
              "index"
            ];
          }
          {
            action = "previous-entry";
            key = "k";
            
            map = [
              "index"
            ];
          }
          {
            action = "view-mailcap";
            key = "<return>";
            
            map = [
              "attach"
            ];
          }
          {
            action = "view-mailcap";
            key = "l";
            
            map = [
              "attach"
            ];
          }
          {
            action = "noop";
            key = "<space>";
            
            map = [
              "editor"
            ];
          }
          {
            action = "last-entry";
            key = "G";
            
            map = [
              "index"
            ];
          }
          {
            action = "exit";
            key = "h";
            
            map = [
              "pager"
              "attach"
            ];
          }
          {
            action = "next-line";
            key = "j";
            
            map = [
              "pager"
            ];
          }
          {
            action = "previous-line";
            key = "k";
            
            map = [
              "pager"
            ];
          }
          {
            action = "view-attachments";
            key = "l";
            
            map = [
              "pager"
            ];
          }
          {
            action = "delete-message";
            key = "D";
            
            map = [
              "index"
            ];
          }
          {
            action = "undelete-message";
            key = "U";
            
            map = [
              "index"
            ];
          }
          {
            action = "limit";
            key = "L";
            
            map = [
              "index"
            ];
          }
          {
            action = "noop";
            key = "h";
            
            map = [
              "index"
            ];
          }
          {
            action = "display-message";
            key = "l";
            
            map = [
              "index"
            ];
          }
          {
            action = "tag-entry";
            key = "<space>";
            
            map = [
              "index"
              "query"
            ];
          }
          {
            action = "goto-parent";
            key = "h";
            
            map = [
              "browser"
            ];
          }
          {
            action = "view-raw-message";
            key = "H";
            
            map = [
              "index"
              "pager"
            ];
          }
          {
            action = "select-entry";
            key = "l";
            
            map = [
              "browser"
            ];
          }
          {
            action = "top-page";
            key = "gg";
            
            map = [
              "browser"
            ];
          }
          {
            action = "bottom-page";
            key = "G";
            
            map = [
              "browser"
            ];
          }
          {
            action = "top";
            key = "gg";
            
            map = [
              "pager"
            ];
          }
          {
            action = "bottom";
            key = "G";
            
            map = [
              "pager"
            ];
          }
          {
            action = "half-down";
            key = "d";
            
            map = [
              "index"
              "pager"
              "browser"
            ];
          }
          {
            action = "half-up";
            key = "u";
            
            map = [
              "index"
              "pager"
              "browser"
            ];
          }
          {
            action = "sync-mailbox";
            key = "S";
            
            map = [
              "index"
              "pager"
            ];
          }
          {
            action = "group-reply";
            key = "R";
            
            map = [
              "index"
              "pager"
            ];
          }
          {
            action = "previous-undeleted";
            key = "\\031";
            
            map = [
              "index"
            ];
          }
          {
            action = "next-undeleted";
            key = "\\005";
            
            map = [
              "index"
            ];
          }
          {
            action = "previous-line";
            key = "\\031";
            
            map = [
              "pager"
            ];
          }
          {
            action = "next-line";
            key = "\\005";
            
            map = [
              "pager"
            ];
          }
          {
            action = "complete-query";
            key = "<Tab>";
            
            map = [
              "editor"
            ];
          }
          {
            action = "sidebar-prev";
            key = "\\Ck";
            
            map = [
              "index"
              "pager"
            ];
          }
          {
            action = "sidebar-next";
            key = "\\Cj";
            
            map = [
              "index"
              "pager"
            ];
          }
          {
            action = "sidebar-open";
            key = "\\Co";
            
            map = [
              "index"
              "pager"
            ];
          }
          {
            action = "sidebar-prev-new";
            key = "\\Cp";
            
            map = [
              "index"
              "pager"
            ];
          }
          {
            action = "sidebar-next-new";
            key = "\\Cn";
            
            map = [
              "index"
              "pager"
            ];
          }
          {
            action = "sidebar-toggle-visible";
            key = "B";
            
            map = [
              "index"
              "pager"
            ];
          }
        ];

        macros = [
          {
            action = "<change-folder>=Inbox<enter>";
            key = "gi";

            map = [
              "index"
              "pager"
            ];
          }
          {
            action = ";<save-message>=Inbox<enter>";
            key = "Mi";

            map = [
              "index"
              "pager"
            ];
          }
          {
            action = ";<copy-message>=Inbox<enter>";
            key = "Ci";
            
            map = [
              "index"
              "pager"
            ];
          }
          {
            action = "<change-folder>=Drafts<enter>";
            key = "gd";
            
            map = [
              "index"
              "pager"
            ];
          }
          {
            action = ";<save-message>=Drafts<enter>";
            key = "Md";
            
            map = [
              "index"
              "pager"
            ];
          }
          {
            action = ";<copy-message>=Drafts<enter>";
            key = "Cd";
            
            map = [
              "index"
              "pager"
            ];
          }
          {
            action = "<change-folder>=Junk<enter>";
            key = "gj";
            
            map = [
              "index"
              "pager"
            ];
          }
          {
            action = ";<save-message>=Junk<enter>";
            key = "Mj";
            
            map = [
              "index"
              "pager"
            ];
          }
          {
            action = ";<copy-message>=Junk<enter>";
            key = "Cj";
            
            map = [
              "index"
              "pager"
            ];
          }
          {
            action = "<change-folder>=Trash<enter>";
            key = "gt";
            
            map = [
              "index"
              "pager"
            ];
          }
          {
            action = ";<save-message>=Trash<enter>";
            key = "Mt";
            
            map = [
              "index"
              "pager"
            ];
          }
          {
            action = ";<copy-message>=Trash<enter>";
            key = "Ct";
            
            map = [
              "index"
              "pager"
            ];
          }
          {
            action = "<change-folder>=Sent<enter>";
            key = "gs";
            
            map = [
              "index"
              "pager"
            ];
          }
          {
            action = ";<save-message>=Sent<enter>";
            key = "Ms";
            
            map = [
              "index"
              "pager"
            ];
          }
          {
            action = ";<copy-message>=Sent<enter>";
            key = "Cs";
            
            map = [
              "index"
              "pager"
            ];
          }
          {
            action = "<change-folder>=Archive<enter>";
            key = "ga";
            
            map = [
              "index"
              "pager"
            ];
          }
          {
            action = ";<save-message>=Archive<enter>";
            key = "Ma";
            
            map = [
              "index"
              "pager"
            ];
          }
          {
            action = ";<copy-message>=Archive<enter>";
            key = "Ca";
            
            map = [
              "index"
              "pager"
            ];
          }
        ];
      };
    };
  };
}
