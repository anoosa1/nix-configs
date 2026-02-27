{
  self,
  inputs,
  ...
}:
{
  flake.nixosModules.anas = {
    imports = [
      inputs.home-manager.nixosModules.home-manager
    ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;

      users = {
        anas = {
          imports = [
            self.homeModules.home
            self.homeModules.anas
            self.homeModules.ssh
          ];
        };
      };
    };

    users = {
      users = {
        anas = {
          isNormalUser = true;
          group = "anas";
          description = "Anas";
          extraGroups = [ "wheel" "audio" "adbusers" "transmission" "immich" "kvm" "minecraft" "open-webui" ];
          openssh = {
            authorizedPrincipals = [
              "anas@astra"
              "anas@aurora"
              "anas@apollo"
            ];

            authorizedKeys = {
              keys = [
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHhK2hN/aKRr12GA6dklSQbL+jG5iQ9OuvXzprvzfGc8 anas@apollo"
              ];
            };
          };
        };
      };

      groups = {
        anas = {
          gid = 1000;
        };
      };
    };
  };

  flake.homeModules.anas = { config, pkgs, ... }: {
    home = {
      username = "anas";
      homeDirectory = "/home/anas";
      preferXdgDirectories = true;

      packages = with pkgs; [
        self.packages.${pkgs.system}.neovim
        gemini-cli
        bat
        bat-extras.batdiff
        bat-extras.batgrep
        bat-extras.batman
        bat-extras.prettybat
        dua
        dust
        eva
        eza
        fd
        gitui
        mpv
        pulsemixer
        ripgrep
        rmpc
        rsync
        rustmission
        steamguard-cli
        yt-dlp
      ];

      sessionPath = [
        "$HOME/.local/bin"
      ];

      sessionVariables = {
        TERMINAL = "kitty";
        BROWSER = "qutebrowser";
        EDITOR = "nvim";

        __GL_SHADER_DISK_CACHE_PATH = "/tmp";
        CUDA_CACHE_PATH = "$XDG_CACHE_HOME/nv";
        ELINKS_CONFDIR = "$XDG_CONFIG_HOME/elinks";
        PROTONPATH = "${pkgs.proton-ge-bin.steamcompattool}";
        INPUTRC = "$XDG_CONFIG_HOME/sh/inputrc";
        MAIL = "$HOME/.local/var/mail";
        PYTHONPYCACHEPREFIX = "$XDG_CACHE_HOME/python";
        PYTHONUSERBASE = "$XDG_DATA_HOME/python";
        SSH_HOME = "$XDG_CONFIG_HOME/ssh";
        STARSHIP_CACHE = "$XDG_CACHE_HOME/starship";
        WINEPREFIX = "$XDG_DATA_HOME/wineprefixes/default";

        _JAVA_AWT_WM_NONREPARENTING = "1";
        _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=\"$XDG_CONFIG_HOME/java\"";
        PASH_DIR = "$XDG_DATA_HOME/passwords";
        AWT_TOOLKIT = "MToolkit wmname LG3D";
        NIXOS_OZONE_WL = "1";
        SUDO_ASKPASS = "$HOME/.local/bin/dmenupass.sh";
        WINIT_X11_SCALE_FACTOR = "1.0";
      };

      shell = {
        enableZshIntegration = true;
      };

      shellAliases = {
        mount = "sudo mount";
        umount = "sudo umount";

        cp = "cp -iv";
        mv = "mv -iv";
        rm = "rm -vI";
        rsync = "rsync -vrPlu";
        mkd = "mkdir -pv";
        yt = "yt-dlp --embed-metadata -i";
        yta = "yt -x -f bestaudio/best";
        ytt = "yt --skip-download --write-thumbnail";
        man = "batman";
        cat = "bat";

        ls = "eza -a --icons --color=always --group-directories-first";
        ll = "eza -lahHmgb --icons --color=always --group-directories-first";
        lt = "eza -aT --icons --color=always --group-directories-first";
        grep = "grep --color=auto";
        diff = "diff --color=auto";
        ccat = "highlight --out-format=ansi";
        ip = "ip -color=auto";

        s = "systemctl";
        j = "journalctl";
        u = "sudo nixos-rebuild switch --flake .";
        "..." = "cd ../..";

        weath = "less -S $XDG_CACHE_HOME/weatherreport";
        se = "se.sh";
        abook = "abook -C .local/etc/abook/abook.conf -f .local/share/abook/addressook";

        z = "zathura";
        e = "nvim";
        k = "pkill";
        g = "git";
      };
    };

    gtk = {
      gtk2 = {
        configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
      };
    };

    xresources = {
      path = "${config.xdg.configHome}/Xresources";
    };

    xdg = {
      cacheHome = "${config.home.homeDirectory}/.local/var/cache";
      configHome = "${config.home.homeDirectory}/.local/etc";
      stateHome = "${config.home.homeDirectory}/.local/var/state";
      dataHome = "${config.home.homeDirectory}/.local/share";

      userDirs = {
        enable = true;
        createDirectories = false;
        desktop = "${config.home.homeDirectory}/desktop";
        documents = "${config.home.homeDirectory}/docs";
        download = "${config.home.homeDirectory}/dls";
        music = "${config.home.homeDirectory}/audio";
        pictures = "${config.home.homeDirectory}/pics";
        videos = "${config.home.homeDirectory}/vids";
        publicShare = "${config.xdg.userDirs.documents}/public";
        templates = "${config.xdg.userDirs.documents}/templates";
      };

      portal = {
        enable = true;
        xdgOpenUsePortal = true;
        config.common.default = "*";

        extraPortals = [
          pkgs.xdg-desktop-portal-gtk
        ];
      };
    };

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
  };
}
