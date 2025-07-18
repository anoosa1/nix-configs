{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.anoosa.zsh.enable {
    programs = {
      zoxide = {
        enable = true;
        enableZshIntegration = true;

        options = [
          "--cmd cd"
        ];
      };
    };
  };
}
