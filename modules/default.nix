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
    ./code-server.nix
    ./docling.nix
    ./home-assistant.nix
    ./home-manager
    ./immich.nix
    ./lobechat.nix
    ./nextcloud.nix
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

