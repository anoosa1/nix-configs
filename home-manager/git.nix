{ config, pkgs, ... }:

{
  programs = {
    git = {
      enable = true;
      userName = "Anas";
      userEmail = "anas@asherif.xyz";
      aliases = {
        co = "checkout";
        c = "commit";
        a = "add -A";
        p = "push";
      };
      extraConfig = {
        commit.gpgsign = true;
        gpg.format = "ssh";
        user.signingkey = "~/.local/etc/ssh/id_ed25519.pub";
      };
    };
  };
}
