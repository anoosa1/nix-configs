{
  services = {
    gpg-agent = {
      enable = true;
      enableZshIntegration = true;
      defaultCacheTtl = 54000;
      maxCacheTtl = 54000;

      extraConfig = ''
        allow-preset-passphrase
      '';
    };
  };
}
