{
  lib,
  config,
  ...
}:
{
  config = lib.mkIf (config.anoosa.niri.enable || config.anoosa.river.enable) {
    services = {
      wpaperd = {
        enable = true;
      };
    };
  };
}
