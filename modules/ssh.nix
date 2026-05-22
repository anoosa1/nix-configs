{
  flake.nixosModules.ssh = {
    services = {
      # Enable the OpenSSH daemon.
      openssh = {
        enable = true;

        # require public key authentication for better security
        settings = {
          PasswordAuthentication = false;
          PermitRootLogin = "no";
          KbdInteractiveAuthentication = false;
          AllowUsers = [ "anas" "gitea" ];
        };
      };
    };
  };

  flake.homeModules.ssh = { config, ... }: {
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

          shafq = {
            hostname = "shafq";
            user = "${config.home.username}";
          };

          git = {
            hostname = "astra";
            user = "${config.home.username}";
            port = 23231;
          };

          astra = {
            hostname = "astra";
            user = "${config.home.username}";
          };

          aurora = {
            hostname = "aurora";
            user = "${config.home.username}";
          };
        };
      };
    };
  };
}
