{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf (config.anoosa.niri.enable || config.anoosa.river.enable) {
    programs = {
      swaylock = {
        enable = true;
      };
    };
  };
}
