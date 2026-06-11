{
  flake.nixosModules.vpn = { pkgs, lib, ... }: {
    ## sops secrets for VPN certs
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
            id = "72.39.65.171";
          };
          remote."0".auth = "pubkey";
          children."ikev2-vpn" = {
            local_ts = [ "0.0.0.0/0" ];
            esp_proposals = [ "aes256-sha256-modp2048" "aes128-sha256-modp2048" ];
          };
          pools = [ "vpn-pool" ];
          send_certreq = false;
          mobike = true;
          fragmentation = "yes";
          dpd_delay = "30s";
          proposals = [ "aes256-sha256-modp2048" "aes128-sha256-modp2048" ];
        };

        authorities."vpnCA" = {
          cacert = "ca-cert.pem";
        };

        pools."vpn-pool" = {
          addrs = "10.100.0.0/24";
          dns = [ "1.1.1.1" "1.0.0.1" ];
          netmask = [ "255.255.255.0" ];
        };
      };
    };

    ## networking
    networking = {
      # Firewall — open IKE and IPsec NAT-T
      firewall.allowedUDPPorts = [ 500 4500 ];
      firewall.extraCommands = ''
        # Accept VPN client traffic — insert before nixos-fw chain
        iptables -I FORWARD 1 -m policy --pol ipsec --dir in -s 10.100.0.0/24 -j ACCEPT
        iptables -I FORWARD 2 -m policy --pol ipsec --dir out -d 10.100.0.0/24 -j ACCEPT
        # MSS clamping for IPsec tunnel overhead
        iptables -I FORWARD 3 -m policy --pol ipsec --dir in -s 10.100.0.0/24 -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --set-mss 1360
      '';

      # NAT masquerade for VPN clients
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
  };
}
