{
  #systemd.user.services = {
  #  "wait-for-path" = {
  #    Unit = {
  #      Description = "wait for systemd units to have full PATH";
  #    };

  #    Install = {
  #      WantedBy = [ "xdg-desktop-portal.service" ];
  #      Before = [ "xdg-desktop-portal.service" ];
  #    };

  #    Service = {
  #      Path = with pkgs; [ systemd coreutils gnugrep ];
  #      ExecStart = "${pkgs.writeShellScript "wait-for-path" ''
  #        #!/bin/sh
  #        ispresent () {
  #          systemctl --user show-environment | grep -E '^PATH=.*/.nix-profile/bin'
  #        }
  #        while ! ispresent; do
  #          sleep 0.1;
  #        done
  #      ''}";
  #      Type = "oneshot";
  #      TimeoutStartSec = "60";
  #    };
  #  };
  #};

  imports = [
    ./dunst.nix
    ./gpg-agent.nix
    ./mpd.nix
    ./pass-secret-service.nix
  ];

  services = {
    playerctld = {
      enable = true;
    };

    wpaperd = {
      enable = true;
    };
  };
}
