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
    ./docling.nix
    ./immich.nix
    ./nextcloud.nix
    ./open-webui.nix
    ./paperless.nix
    ./searx.nix
    ./soft-serve.nix
    ./tailscale.nix
    ./vaultwarden.nix
    ./website.nix
  ];
}

