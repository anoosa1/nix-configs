{
  programs = {
    skim = {
      enable = true;
      enableZshIntegration = true;
      changeDirWidgetCommand = "fd --type d";
      fileWidgetCommand = "fd --type f";

      defaultOptions = [
        "--prompt >"
        "--height 15"
      ];
    };
  };
}
