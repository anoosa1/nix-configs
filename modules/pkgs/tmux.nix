# modules/pkgs/tmux.nix
{
  inputs,
  ...
}:
{
  flake.wrappers.tmux = { pkgs, ... }: {
    imports = [ inputs.wrappers.lib.wrapperModules.tmux ];
    allowPassthrough = true;
    baseIndex = 1;
    clock24 = true;
    configAfter = ''set -g @catppuccin_window_current_number_color "#{@thm_pink}"'';
    historyLimit = 5000;
    modeKeys = "vi";
    mouse = true;
    plugins = [ pkgs.tmuxPlugins.catppuccin ];
    prefix = "Space";
    terminal = "screen-256color";
  };
}
