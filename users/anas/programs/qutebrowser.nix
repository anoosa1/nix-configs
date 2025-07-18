{
  lib,
  config,
  ...
}:
{
  options.anoosa.qutebrowser.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable qutebrowser";
    example = true;
  };

  config = lib.mkIf config.anoosa.qutebrowser.enable {
    programs = {
      qutebrowser = {
        enable = true;

        quickmarks = {
          nixsearch = "https://search.nixos.org/";
          hmsearch = "https://home-manager-options.extranix.com/?query=&release=master";
        };

        searchEngines = {
          g = "https://www.google.com/search?hl=en&q={}";
        };
      };
    };
  };
}
