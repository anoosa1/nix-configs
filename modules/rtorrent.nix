{
  lib,
  config,
  ...
}:
{
  options.anoosa.rtorrent = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable rtorrent";
      example = true;
    };
  };

  config = lib.mkIf config.anoosa.rtorrent.enable {
    services.rtorrent = {
      enable = true;
      port = 50000;
      openFirewall = true;
    };
  };
}
