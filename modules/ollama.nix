{
  lib,
  config,
  ...
}:
{
  options.anoosa.ollama.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable ollama";
    example = true;
  };

  config = lib.mkIf config.anoosa.ollama.enable {
    services = {
      ollama = {
        enable = true;
        acceleration = "cuda";
        host = "0.0.0.0";
      };
    };
  };
}
