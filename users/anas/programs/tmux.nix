{
  pkgs,
  ...
}:
{
  programs = {
    tmux = {
      enable = true;
      baseIndex = 1;
      clock24 = true;
      focusEvents = true;
      historyLimit = 5000;
      keyMode = "vi";
      mouse = true;
      #sensibleOnTop = true;
      shell = "${pkgs.fish}/bin/fish";
      shortcut = "Space";
      terminal = "screen-256color";
    };
  };
}
