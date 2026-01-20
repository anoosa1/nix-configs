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
    "4get" = {
      enable = true;
    };

    code-server = {
      enable = true;
    };

    copyparty = {
      enable = true;
    };

    gitea = {
      enable = true;
    };

    home-assistant = {
      enable = true;
    };

    immich = {
      enable = true;
    };

    lobechat = {
      enable = false;
    };

    nextcloud = {
      enable = true;
    };

    nitter = {
      enable = true;
    };

    open-webui = {
      enable = false;
    };

    paperless = {
      enable = true;
    };

    searx = {
      enable = false;
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
