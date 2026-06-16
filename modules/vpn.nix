{
  flake.nixosModules.vpn = { pkgs, lib, ... }: {
    ## sops secrets for VPN certs and EAP password
    sops.secrets = {
      "vpn/ca-cert" = {
        mode = "0444";
      };

      "vpn/server-cert" = {
        mode = "0444";
      };

      "vpn/server-key" = {
        mode = "0440";
      };

      "vpn/eap-password" = {
        mode = "0440";
      };
    };

    ## stage certs into swanctl dirs (sops puts them in /run/secrets/)
    systemd.tmpfiles.rules = [
      "L+ /etc/swanctl/x509ca/ca-cert.pem - - - - /run/secrets/vpn/ca-cert"
      "L+ /etc/swanctl/x509/server-cert.pem - - - - /run/secrets/vpn/server-cert"
      "L+ /etc/swanctl/private/server-key.pem - - - - /run/secrets/vpn/server-key"
    ];

    ## services
    services.strongswan-swanctl = {
      enable = true;
      swanctl = {
        connections."ikev2-vpn" = {
          version = 2;
          local."0" = {
            auth = "pubkey";
            certs = [ "server-cert.pem" ];
            id = "astra.asherif.xyz";
          };
          remote."0" = {
            auth = "eap-mschapv2";
            eap_id = "%any";
          };
          children."ikev2-vpn" = {
            local_ts = [ "0.0.0.0/0" ];
            esp_proposals = [ "aes256-sha256-modp2048" "aes128-sha256-modp2048" ];
          };
          pools = [ "vpn-pool" ];
          mobike = true;
          fragmentation = "yes";
          dpd_delay = "30s";
          proposals = [ "aes256-sha256-modp2048" "aes128-sha256-modp2048" ];
        };

        pools."vpn-pool" = {
          addrs = "10.100.0.0/24";
          dns = [ "1.1.1.1" "1.0.0.1" ];
        };

        ## EAP-MSCHAPv2 credential
        ## Password is loaded from sops secret /run/secrets/vpn/eap-password
        ## (the includes mechanism reads it without putting it in the Nix store)
      };

      ## include eap secret from a file outside the Nix store (sops-managed)
      includes = [ "/etc/swanctl/conf.d/eap-secret.conf" ];
    };

    ## write EAP secret file from sops-managed secret at activation time
    systemd.services.strongswan-swanctl.preStart = lib.mkAfter ''
      mkdir -p /etc/swanctl/conf.d
      cat > /etc/swanctl/conf.d/eap-secret.conf <<SWANCTL
      secrets {
        eap-vpn {
          id = anas
          secret = "$(cat /run/secrets/vpn/eap-password)"
        }
      }
      SWANCTL
      chmod 600 /etc/swanctl/conf.d/eap-secret.conf
    '';

    ## networking
    networking = {
      # Firewall — open IKE and IPsec NAT-T
      firewall.allowedUDPPorts = [ 500 4500 ];
      firewall.extraCommands = ''
        # IPsec forwarding — insert before nixos-fw chain (which ends in DROP)
        iptables -I FORWARD 1 -m policy --pol ipsec --dir in -s 10.100.0.0/24 -j ACCEPT
        iptables -I FORWARD 2 -m policy --pol ipsec --dir out -d 10.100.0.0/24 -j ACCEPT
        # MSS clamping for IPsec tunnel overhead (avoids fragmentation)
        iptables -I FORWARD 3 -m policy --pol ipsec --dir in -s 10.100.0.0/24 -o eno1 -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --set-mss 1360
      '';

      # NAT masquerade for VPN clients — use NixOS module (reliable), not raw iptables
      nat = {
        enable = true;
        internalIPs = [ "10.100.0.0/24" ];
        externalInterface = "eno1";
      };
    };

    ## kernel — IP forwarding for VPN
    boot.kernel.sysctl = {
      "net.ipv4.ip_forward" = 1;
      "net.ipv6.conf.all.forwarding" = 1;
    };

    ## system packages — strongswan for troubleshooting
    environment.systemPackages = [ pkgs.strongswan ];

    ## charon debug logging to file
    environment.etc."strongswan.d/charon-logging.conf".text = ''
      charon {
        filelog {
          /tmp/charon-debug.log {
            time_format = %b %e %T
            ike_name = yes
            append = yes
            default = 3
            mgr = 3
            ike = 3
            chd = 3
            cfg = 3
            knl = 3
            net = 3
            enc = 3
            asn = 3
            tls = 3
          }
        }
      }
    '';
  };
}
