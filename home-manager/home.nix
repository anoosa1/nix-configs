{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "anas";
  home.homeDirectory = "/home/anas";
  home.sessionPath = [
    "$HOME/.local/bin"
  ];
  xdg.cacheHome = "/home/anas/.local/var/cache";
  xdg.configHome = "/home/anas/.local/etc";
  xdg.stateHome = "/home/anas/.local/var/state";

  fonts.fontconfig.enable = true;

  imports =
    [
      ./alacritty.nix
      ./bat.nix
      ./git.nix
      ./hyprland.nix
      ./lf/lf.nix
      #./ncmpcpp.nix
      ./services.nix
      ./starship.nix
      ./stylix.nix
      #./x.nix
      ./zsh.nix
    ];

    nixpkgs = {
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    python312Packages.beautifulsoup4
    python312Packages.requests
    python3

    rustc
    cargo
    bemenu
    gtk4
    chafa
    du-dust
    eva
    eza
    fd
    fzf
    libsixel
    monocraft
    mpv
    nsxiv
    #passExtensions.pass-audit
    #passExtensions.pass-genphrase
    #passExtensions.pass-import
    #passExtensions.pass-otp
    #passExtensions.pass-tomb
    #passExtensions.pass-update
    #(pass.withExtensions (ext: with ext; [ pass-audit pass-otp pass-import pass-genphrase pass-update pass-tomb ]))
    ripgrep
    rsync
    skim
    tty-clock
    wget
    zathura
    zig

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a

    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    ".local/etc/wget/wgetrc".text = ''
      hsts-file=~/.local/var/state/wget-hsts
    '';

    ".local/share/flatpak/overrides/global".text = ''
      [Context]
      filesystems=/run/current-system/sw/share/X11/fonts:ro;/nix/store:ro;xdg-config/gtk-4.0:ro;xdg-config/gtk-3.0:ro
    '';

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  dconf.settings."org/gnome/desktop/wm/preferences".button-layout = "appmenu:minimize,maximize,close";

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/anas/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = rec {
    TERMINAL = "alacritty";
    BROWSER = "com.google.Chrome";

    XDG_DESKTOP_DIR = "$HOME/desktop";
    XDG_DOCUMENTS_DIR = "$HOME/docs";
    XDG_DOWNLOAD_DIR = "$HOME/dls";
    XDG_MUSIC_DIR = "$HOME/audio";
    XDG_PICTURES_DIR = "$HOME/pics";
    XDG_PUBLICSHARE_DIR = "$HOME/docs/public";
    XDG_TEMPLATES_DIR = "$HOME/docs/templates";
    XDG_VIDEOS_DIR = "$HOME/vids";
    XDG_APPLICATIONS_DIR = "$HOME/docs/apps";
    XDG_CONFIG_HOME = "$HOME/.local/etc";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_CACHE_HOME = "$HOME/.local/var/cache";
    XDG_STATE_HOME = "$HOME/.local/var/state";
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
    MBSYNCRC = "$XDG_CONFIG_HOME/mbsync/config";
    NOTMUCH_CONFIG = "$XDG_CONFIG_HOME/notmuch-config";
    PASH_DIR = "$XDG_DATA_HOME/passwords";
    PASSWORD_STORE_DIR = "$XDG_DATA_HOME/passwords";
    PYTHONPYCACHEPREFIX = "$XDG_CACHE_HOME/python";
    PYTHONUSERBASE = "$XDG_DATA_HOME/python";
    RUSTUP_HOME = "$XDG_DATA_HOME/rustup";
    SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/gcr/ssh";
    SSH_HOME = "$XDG_CONFIG_HOME/ssh";
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
    SUDO_ASKPASS = "$HOME/.local/bin/dmenupass.sh";
    WINIT_X11_SCALE_FACTOR = "1.0";
  };

  qt = {
    enable = true;
    platformTheme = {
      name = "gtk";
    };
  };

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;
    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [
        "--cmd cd"
      ];
    };
  };
}
