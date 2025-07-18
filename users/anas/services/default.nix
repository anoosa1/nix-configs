{
  imports = [
    ./dunst.nix
    ./gpg-agent.nix
    ./mpd.nix
    ./pass-secret-service.nix
    ./wpaperd.nix
  ];

  services = {
    playerctld = {
      enable = true;
    };
  };
}
