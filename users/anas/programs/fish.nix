{
  programs = {
    fish = {
      enable = true;

      shellInit = ''
        umask 077
        fish_vi_key_bindings
        set -U fish_greeting
      '';

      functions = {
        lfcd = "cd \"$(command lf -print-last-dir $argv)\"";
      };
    };
  };
}
