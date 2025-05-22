{
  accounts = {
    email = {
      maildirBasePath = ".local/var/mail";
      accounts = {
        "anas@waifu.club" = {
          address = "anas@waifu.club";
          userName = "anas@waifu.club";
          passwordCommand = "testpass.sh";
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
            create = "both";
            expunge = "both";
          };

          msmtp = {
            enable = true;
          };

          neomutt = {
            enable = true;
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
