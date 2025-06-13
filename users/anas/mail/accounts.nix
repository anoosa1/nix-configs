{
  accounts = {
    email = {
      maildirBasePath = ".local/var/mail";
      accounts = {
        "anas@waifu.club" = {
          address = "anas@waifu.club";
          userName = "anas@waifu.club";
          passwordCommand = "pa.sh s mail.cock.li";
          primary = true;
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

            extraMailboxes = [
              "Archive"
              "Drafts"
              "Junk"
              "Queue"
              "Sent"
              "Trash"
            ];
          };

          notmuch = {
            enable = true;

            neomutt = {
              enable = true;
            };
          };
        };
      };
    };
  };
}
