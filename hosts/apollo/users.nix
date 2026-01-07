{
  anoosa = {
    tailscale = {
      enable = true;
    };
  };

  home-manager = {
    users = {
      anas = {
        anoosa = {
          direnv = {
            enable = true;
          };

          git = {
            enable = true;

            user = {
              email = "anas@asherif.xyz";
            };
          };

          gpg = {
            enable = true;
          };

          lf = {
            enable = true;
          };

          mbsync = {
            enable = true;
          };

          neomutt = {
            enable = true;
          };

          newsboat = {
            enable = true;
          };

          niri = {
            enable = true;
          };

          notmuch = {
            enable = true;
          };

          password-store = {
            enable = true;
          };

          qutebrowser = {
            enable = true;
          };

          skim = {
            enable = true;
          };

          ssh = {
            enable = true;
          };

          tmux = {
            enable = true;
          };

          zsh = {
            enable = true;
          };

          rclone = {
            enable = true;
          };
        };
      };
    };
  };
}
