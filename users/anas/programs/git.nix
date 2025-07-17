{
  lib,
  config,
  ...
}:
{
  options.anoosa.git.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable git";
    example = true;
  };

  config = lib.mkIf config.anoosa.git.enable {
    programs = {
      git = {
        enable = true;
        userName = "Anas";
        userEmail = "anas@asherif.xyz";

        aliases = {
          co = "checkout";
          c = "commit -a";
          a = "add -A";
          p = "push";
        };

        extraConfig = {
          commit.gpgsign = true;
          gpg.format = "ssh";
          user.signingkey = "~/.local/etc/ssh/id_ed25519.pub";
        };

        delta = {
          enable = true;
        };
      };
    };
  };
}
