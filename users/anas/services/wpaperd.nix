{
  lib,
  config,
  ...
}:
{
  config = lib.mkIf config.anoosa.niri.enable {
    services = {
      wpaperd = {
        enable = true;
      };
    };
  };
}
