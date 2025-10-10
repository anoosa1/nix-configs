{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.anoosa.niri.enable {
    programs = {
      swaylock = {
        enable = true;
      };
    };
  };
}
