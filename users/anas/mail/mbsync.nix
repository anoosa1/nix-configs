{
  pkgs,
  ...
}:
{
  home.packages = [
    pkgs.cyrus-sasl-xoauth2
  ];

  programs = {
    mbsync = {
      enable = true;
      package = pkgs.isync.override { withCyrusSaslXoauth2 = true; };
    };
  };
}
