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
    stateVersion = "24.11";

    sessionPath = [
      "$HOME/.local/bin"
    ];

    packages = with pkgs; [
      bluetui
      waypipe
      brave
      brightnessctl
      chafa
      du-dust
      rustmission
      dua
      eva
      eza
      libsixel
      localsend
      monocraft
      vimv-rs
      mpv
      neovim
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
      scripts.se
      simplex-chat-desktop
      tokei
      tty-clock
      umu-launcher
      vscode
      waylock
      wget
      wlr-randr
      yt-dlp
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
      PROTONPATH = "${pkgs.proton-ge-bin.steamcompattool}";
      INPUTRC = "$XDG_CONFIG_HOME/sh/inputrc";
      KODI_DATA = "$XDG_DATA_HOME/kodi";
      MAIL = "$HOME/.local/var/mail";
      PYTHONPYCACHEPREFIX = "$XDG_CACHE_HOME/python";
      PYTHONUSERBASE = "$XDG_DATA_HOME/python";
      RUSTUP_HOME = "$XDG_DATA_HOME/rustup";
      SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/gcr/ssh";
      SSH_HOME = "$XDG_CONFIG_HOME/ssh";
      XKB_DEFAULT_OPTIONS = "caps:swapescape";
      STARSHIP_CACHE = "$XDG_CACHE_HOME/starship";
      STARSHIP_CONFIG = "$XDG_CONFIG_HOME/starship.toml";
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "$HOME/.steam/root/compatibilitytools.d";
      UNISON = "$XDG_DATA_HOME/unison";
      WGETRC = "$XDG_CONFIG_HOME/wget/wgetrc";
      WINEPREFIX = "$XDG_DATA_HOME/wineprefixes/default";
      XAUTHORITY = "$XDG_RUNTIME_DIR/Xauthority";
      XINITRC = "$XDG_CONFIG_HOME/X11/xsession.sh";
      XRESOURCES = "$XDG_CONFIG_HOME/X11/Xresources";
      ZDOTDIR = "$XDG_CONFIG_HOME/zsh";

      _JAVA_AWT_WM_NONREPARENTING = "1";
      _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=\"$XDG_CONFIG_HOME/java\"";
      PASH_DIR = "$XDG_DATA_HOME/passwords";
      AWT_TOOLKIT = "MToolkit wmname LG3D";
      DICS = "/usr/share/stardict/dic/";
      FZF_DEFAULT_OPTS = "--layout=reverse --height 40%";
      MOZ_USE_XINPUT2 = "1";
      NIXOS_OZONE_WL = "1";
      SUDO_ASKPASS = "$HOME/.local/bin/dmenupass.sh";
      WINIT_X11_SCALE_FACTOR = "1.0";
    };

    shell = {
      enableZshIntegration = true;
      enableFishIntegration = true;
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
      ffmpeg = "ffmpeg -hide_banner";

      ls = "eza -a --icons --color=always --group-directories-first";
      ll = "eza -lahHmgb --icons --color=always --group-directories-first";
      lt = "eza -aT --icons --color=always --group-directories-first";
      grep = "grep --color=auto";
      diff = "diff --color=auto";
      ccat = "highlight --out-format=ansi";
      ip = "ip -color=auto";

      trem = "transmission-remote";
      s = "systemctl";
      j = "journalctl";
      "..." = "cd ../..";

      magit = "nvim -c MagitOnly";
      weath = "less -S $XDG_CACHE_HOME/weatherreport";
      se = "se.sh";
      abook = "abook -C .local/etc/abook/abook.conf -f .local/share/abook/addressook";

      z = "zathura";
      e = "nvim";
      k = "pkill";
      g = "git";

      astra = "ssh astra";
    };
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
    zoxide = {
      enable = true;
      enableZshIntegration = true;
      enableFishIntegration = true;

      options = [
        "--cmd cd"
      ];
    };
  };
}
