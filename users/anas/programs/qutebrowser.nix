{
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
}
