{
  home-manager = {
    users = {
      anas = {
        anoosa = {
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

          notmuch = {
            enable = true;
          };

          password-store = {
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
        };
      };
    };
  };

  anoosa = {
    code-server = {
      enable = true;
    };

    home-assistant = {
      enable = true;
    };

    immich = {
      enable = true;
    };

    nextcloud = {
      enable = true;
    };

    open-webui = {
      enable = true;
    };

    paperless = {
      enable = true;
    };

    searx = {
      enable = true;
    };

    soft-serve = {
      enable = true;
    };

    tailscale = {
      enable = true;
    };

    transmission = {
      enable = true;
    };

    vaultwarden = {
      enable = true;
    };

    website = {
      enable = true;
    };
  };
}
