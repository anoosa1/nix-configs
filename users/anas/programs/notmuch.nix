{
  programs = {
    notmuch = {
      enable = true;

      hooks = {
        preNew = "mbsync --all";
      };
    };
  };
}
