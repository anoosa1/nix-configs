{
  lib,
  ...
}:
{
  options.anoosa = {
    domain = lib.mkOption {
      type = lib.types.str;
      default = "asherif.xyz";
      description = "Domain name for services";
      example = "example.org";
    };
  };

  imports = [
    ./4get.nix
    ./code-server.nix
    ./copyparty.nix
    ./docling.nix
    ./gitea.nix
    ./home-assistant.nix
    ./home-manager
    ./immich.nix
    ./lobechat.nix
    ./nextcloud.nix
    ./nitter.nix
    ./open-webui.nix
    ./paperless.nix
    ./searx.nix
    ./soft-serve.nix
    ./transmission.nix
    ./tailscale.nix
    ./vaultwarden.nix
    ./website.nix
  ];
}

