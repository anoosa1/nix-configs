{
  accounts = {
    email = {
      maildirBasePath = ".local/var/mail";
      accounts = {
        "anas_sherif1@outlook.com" = {
          address = "anas_sherif1@outlook.com";
          userName = "anas_sherif1@outlook.com";
          passwordCommand = "mutt_oauth2.py ~/.local/share/passwords/outlook.com.gpg";
          primary = true;
          realName = "Anas";

          signature = {
            text = "Anas";
            showSignature = "append";
          };

          imap = {
            host = "outlook.office365.com";
          };

          smtp = {
            host = "smtp-mail.office365.com";
            port = 587;
            
            tls = {
              useStartTls = true;
            };
          };

          mbsync = {
            enable = true;
            create = "maildir";
            expunge = "maildir";

            extraConfig = {
              account = {
                User = "anas_sherif1@outlook.com";
                AuthMechs = "XOAUTH2";
              };
            };
          };

          msmtp = {
            enable = true;

            extraConfig = {
              protocol = "smtp";
              tls = "on";
              tls_starttls = "on";
              auth = "xoauth2";
              user = "anas_sherif1@outlook.com";
              passwordeval = "mutt_oauth2.py ~/.local/share/passwords/outlook.com.gpg";
            };
          };

          neomutt = {
            enable = true;
            mailboxName = "Inbox";

            extraConfig = ''
              macro index,pager i2 '<sync-mailbox><enter-command>source ~/.local/etc/neomutt/anas@waifu.club<enter><change-folder>!<enter>'
              macro index,pager i1 '<sync-mailbox><enter-command>source ~/.local/etc/neomutt/anas_sherif1@outlook.com<enter><change-folder>!<enter>'
            '';

            extraMailboxes = [
              "Archive"
              "Drafts"
              "Junk"
              "Sent"
            ];
          };

          notmuch = {
            enable = true;

            neomutt = {
              enable = true;

              virtualMailboxes = [
                {
                  name = "Archive";
                  query = "folder:anas_sherif1@outlook.com/Archive";
                }
                {
                  name = "Drafts";
                  query = "folder:anas_sherif1@outlook.com/Drafts";
                }
                {
                  name = "Inbox";
                  query = "path:anas_sherif1@outlook.com/Inbox/**";
                }
                {
                  name = "Junk";
                  query = "folder:anas_sherif1@outlook.com/Junk";
                }
                {
                  name = "Sent";
                  query = "folder:anas_sherif1@outlook.com/Sent";
                }
              ];
            };
          };
        };
        "anas@waifu.club" = {
          address = "anas@waifu.club";
          userName = "anas@waifu.club";
          passwordCommand = "pa.sh s mail.cock.li";
          realName = "Anas";

          signature = {
            text = "Anas";
            showSignature = "append";
          };

          imap = {
            host = "mail.cock.li";
          };

          smtp = {
            host = "mail.cock.li";
          };

          mbsync = {
            enable = true;
            create = "maildir";
            expunge = "maildir";
          };

          msmtp = {
            enable = true;
          };

          neomutt = {
            enable = true;
            mailboxName = "Inbox";

            extraConfig = ''
              macro index,pager i2 '<sync-mailbox><enter-command>source ~/.local/etc/neomutt/anas@waifu.club<enter><change-folder>!<enter>'
              macro index,pager i1 '<sync-mailbox><enter-command>source ~/.local/etc/neomutt/anas_sherif1@outlook.com<enter><change-folder>!<enter>'
            '';

            extraMailboxes = [
              "Archive"
              "Drafts"
              "Junk"
              "Sent"
              "Trash"
            ];
          };

          notmuch = {
            enable = true;

            neomutt = {
              enable = true;

              virtualMailboxes = [
                {
                  name = "Archive";
                  query = "folder:anas@waifu.club/Archive";
                }
                {
                  name = "Drafts";
                  query = "folder:anas@waifu.club/Drafts";
                }
                {
                  name = "Inbox";
                  query = "path:anas@waifu.club/Inbox/**";
                }
                {
                  name = "Junk";
                  query = "folder:anas@waifu.club/Junk";
                }
                {
                  name = "Sent";
                  query = "folder:anas@waifu.club/Sent";
                }
                {
                  name = "Trash";
                  query = "folder:anas@waifu.club/Trash";
                }
              ];
            };
          };
        };
      };
    };
  };
}
