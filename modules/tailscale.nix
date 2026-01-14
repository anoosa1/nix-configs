{
  lib,
  config,
  ...
}:
{
  options.anoosa.tailscale = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable tailscale";
      example = true;
    };
  };

  config = lib.mkIf config.anoosa.tailscale.enable {
    services = {
      tailscale = {
        enable = true;
        useRoutingFeatures = "both";
      };
    };
  };
}
