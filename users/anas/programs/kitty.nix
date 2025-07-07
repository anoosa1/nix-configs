{
  programs = {
    kitty = {
      enable = true;
      themeFile = "gruvbox-dark-hard";

      shellIntegration = {
        enableZshIntegration = true;
      };

      settings = {
        window_padding_width = 10;
        scrollback_lines = 5000;
      };
    };
  };
}
