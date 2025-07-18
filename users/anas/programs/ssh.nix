{
  lib,
  config,
  ...
}:
{
  options.anoosa.ssh.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable ssh";
    example = true;
  };

  config = lib.mkIf config.anoosa.ssh.enable {
    programs = {
      ssh = {
        enable = true;
        userKnownHostsFile = "${config.xdg.dataHome}/ssh/known_hosts.d/%k";

        matchBlocks = {
          apollo = {
            identityFile = "${config.xdg.configHome}/ssh/id_ed25519";
            hostname = "apollo.asherif.xyz";
            user = "anas";
          };
          astra = {
            identityFile = "${config.xdg.configHome}/ssh/id_ed25519";
            hostname = "astra.asherif.xyz";
            user = "anas";
          };
          aurora = {
            identityFile = "${config.xdg.configHome}/ssh/id_ed25519";
            hostname = "aurora.asherif.xyz";
            user = "anas";
          };
        };
      };
    };
  };
}
