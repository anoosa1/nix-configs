{
  pkgs,
  config,
  ...
}:
{
  imports = [
    ./mail
    ./programs
    ./river
    ./services.nix
    ./stylix.nix
  ];

  fonts.fontconfig.enable = true;

  systemd.user.services = {
    "wait-for-path" = {
      Unit = {
        Description = "wait for systemd units to have full PATH";
      };

      Install = {
        WantedBy = [ "xdg-desktop-portal.service" ];
        Before = [ "xdg-desktop-portal.service" ];
      };

      Service = {
        Path = with pkgs; [ systemd coreutils gnugrep ];
        ExecStart = "${pkgs.writeShellScript "wait-for-path" ''
          #!/bin/sh
          ispresent () {
            systemctl --user show-environment | grep -E '^PATH=.*/.nix-profile/bin'
          }
          while ! ispresent; do
            sleep 0.1;
          done
        ''}";
        Type = "oneshot";
        TimeoutStartSec = "60";
      };
    };
  };

  home = {
    username = "anas";
    homeDirectory = "/home/anas";
    sessionPath = [
      "$HOME/.local/bin"
    ];

    packages = with pkgs; [
      #grayjay
      yt-dlp
      scripts.se
      scripts.dmenuhandler
      neovim
      bluetui
      brave
      brightnessctl
      chafa
      du-dust
      eva
      eza
      fd
      libsixel
      localsend
      monocraft
      mpv
      nsxiv
      pamixer
      playerctl
      prismlauncher
      pulsemixer
      qutebrowser
      ripgrep
      rmpc
      rofi-wayland
      rsync
      simplex-chat-desktop
      tty-clock
      umu-launcher
      vscode
      waylock
      wget
      wlr-randr
      zathura

      # # You can create simple shell scripts directly inside your
      # # configuration. For example, this adds a command 'my-hello' to your
      # # environment:
      # (pkgs.writeShellScriptBin "my-hello" ''
      #   echo "Hello, ${config.home.username}!"
      # '')
    ];

    file = {
      # # symlink to the Nix store copy.
      # ".screenrc".source = dotfiles/screenrc;

      ".local/etc/wget/wgetrc".text = ''
        hsts-file=~/.local/var/state/wget-hsts
      '';
    };

    sessionVariables = {
      TERMINAL = "alacritty";
      BROWSER = "brave";
      EDITOR = "nvim";

      XDG_APPLICATIONS_DIR = "$HOME/docs/apps";
      XDG_BIN_HOME = "$HOME/.local/bin";

      __GL_SHADER_DISK_CACHE_PATH = "/tmp";
      ANSIBLE_CONFIG = "$XDG_CONFIG_HOME/ansible/ansible.cfg";
      CARGO_HOME = "$XDG_DATA_HOME/cargo";
      CUDA_CACHE_PATH = "$XDG_CACHE_HOME/nv";
      ELECTRUMDIR = "$XDG_DATA_HOME/electrum";
      ELINKS_CONFDIR = "$XDG_CONFIG_HOME/elinks";
      ERRFILE = "$XDG_CACHE_HOME/X11/xsession-errors";
      GOBIN = "$XDG_BIN_HOME/go";
      GOMODCACHE = "$XDG_CACHE_HOME/go/mod";
      GOPATH = "$XDG_DATA_HOME/go";
      INPUTRC = "$XDG_CONFIG_HOME/sh/inputrc";
      KODI_DATA = "$XDG_DATA_HOME/kodi";
      MAIL = "$HOME/.local/var/spool/mail";
      PYTHONPYCACHEPREFIX = "$XDG_CACHE_HOME/python";
      PYTHONUSERBASE = "$XDG_DATA_HOME/python";
      RUSTUP_HOME = "$XDG_DATA_HOME/rustup";
      SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/gcr/ssh";
      SSH_HOME = "$XDG_CONFIG_HOME/ssh";
      XKB_DEFAULT_OPTIONS = "caps:swapescape";
      STARSHIP_CACHE = "$XDG_CACHE_HOME/starship";
      STARSHIP_CONFIG = "$XDG_CONFIG_HOME/starship.toml";
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "$HOME/.steam/root/compatibilitytools.d";
      TMUX_TMPDIR = "$XDG_RUNTIME_DIR";
      UNISON = "$XDG_DATA_HOME/unison";
      WGETRC = "$XDG_CONFIG_HOME/wget/wgetrc";
      WINEPREFIX = "$XDG_DATA_HOME/wineprefixes/default";
      XAUTHORITY = "$XDG_RUNTIME_DIR/Xauthority";
      XINITRC = "$XDG_CONFIG_HOME/X11/xsession.sh";
      XRESOURCES = "$XDG_CONFIG_HOME/X11/Xresources";
      ZDOTDIR = "$XDG_CONFIG_HOME/zsh";

      _JAVA_AWT_WM_NONREPARENTING = "1";
      _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=\"$XDG_CONFIG_HOME/java\"";
      AWT_TOOLKIT = "MToolkit wmname LG3D";
      DICS = "/usr/share/stardict/dic/";
      FZF_DEFAULT_OPTS = "--layout=reverse --height 40%";
      MOZ_USE_XINPUT2 = "1";
      NIXOS_OZONE_WL = "1";
      SUDO_ASKPASS = "$HOME/.local/bin/dmenupass.sh";
      WINIT_X11_SCALE_FACTOR = "1.0";
    };

    stateVersion = "24.11";
  };

  xdg = {
    cacheHome = "${config.home.homeDirectory}/.local/var/cache";
    configHome = "${config.home.homeDirectory}/.local/etc";
    stateHome = "${config.home.homeDirectory}/.local/var/state";
    dataHome = "${config.home.homeDirectory}/.local/share";

    userDirs = {
      enable = true;
      createDirectories = true;
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

      config = {
        river = {
          default = [ "gtk" ];
          "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
          "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
        };
      };

      extraPortals = [
        pkgs.xdg-desktop-portal-wlr
        pkgs.xdg-desktop-portal-gtk
      ];
    };
  };

  programs = {
    home-manager = {
      enable = true;
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [
        "--cmd cd"
      ];
    };
  };
}
