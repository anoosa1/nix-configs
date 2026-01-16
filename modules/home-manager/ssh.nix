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
        enableDefaultConfig = false;

        matchBlocks = {
          "*" = {
            addKeysToAgent = "no";
            compression = false;
            controlMaster = "no";
            controlPath = "${config.xdg.dataHome}/ssh/master-%r@%n:%p";
            controlPersist = "no";
            forwardAgent = false;
            hashKnownHosts = false;
            serverAliveCountMax = 3;
            serverAliveInterval = 0;
            userKnownHostsFile = "${config.xdg.dataHome}/ssh/known_hosts.d/%k";
            identityFile = "${config.xdg.configHome}/ssh/id_ed25519";
          };

          apollo = {
            hostname = "apollo.asherif.xyz";
            user = "${config.home.username}";
          };

          git = {
            hostname = "git.asherif.xyz";
            user = "${config.home.username}";
            port = 23231;
          };

          gitlocal = {
            hostname = "localhost";
            user = "${config.home.username}";
            port = 23231;
          };

          astra = {
            hostname = "astra.asherif.xyz";
            user = "${config.home.username}";
          };

          aurora = {
            hostname = "aurora.asherif.xyz";
            user = "${config.home.username}";
          };
        };
      };
    };
  };
}
