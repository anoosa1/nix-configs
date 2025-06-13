{
  services = {
    mpd = {
      enable = true;
      musicDirectory = "~/audio";

      network = {
        listenAddress = "any";
        port = 6600;
        startWhenNeeded = true;
      };
    };
  };
}
