{
  pkgs,
  ...
}:
{
  home = {
    sessionPath = [
      "$HOME/.local/bin"
    ];

    sessionVariables = {
      TERMINAL = "alacritty";
      BROWSER = "brave";
      EDITOR = "nvim";

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
      SSH_HOME = "$XDG_CONFIG_HOME/ssh";
      XKB_DEFAULT_OPTIONS = "caps:swapescape";
      STARSHIP_CACHE = "$XDG_CACHE_HOME/starship";
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "$HOME/.steam/root/compatibilitytools.d";
      UNISON = "$XDG_DATA_HOME/unison";
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
  };
}
