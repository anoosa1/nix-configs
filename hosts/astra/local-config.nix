{
  nixpkgs.config.allowBroken = true;
  anoosa = {
    immich = {
      enable = true;
    };

    nextcloud = {
      enable = true;
    };

    open-webui = {
      enable = true;
    };

    paperless = {
      enable = true;
    };

    searx = {
      enable = true;
    };

    soft-serve = {
      enable = true;
    };

    tailscale = {
      enable = true;
    };

    vaultwarden = {
      enable = true;
    };

    website = {
      enable = true;
    };
  };
}
