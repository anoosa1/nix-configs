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
            local_ts = [ "10.0.0.0/24" ];
            esp_proposals = [ "aes256-sha256-modp2048" "aes128-sha256-modp2048" ];
          };
          pools = [ "vpn-pool" "vpn-pool6" ];
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

        pools."vpn-pool6" = {
          addrs = "fd00:cafe::/104";
        };   
      };
    };

    ## networking
    networking = {
      # Firewall — open IKE and IPsec NAT-T
      firewall.allowedUDPPorts = [ 500 4500 ];
      firewall.extraCommands = ''
        # Policies: allow by default, drop unmatched at end (blog approach)
        iptables -P INPUT ACCEPT
        iptables -P FORWARD ACCEPT
        iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
        # Allow VPN forwarded traffic
        iptables -A FORWARD -m policy --pol ipsec --dir in -s 10.100.0.0/24 -j ACCEPT
        iptables -A FORWARD -m policy --pol ipsec --dir out -d 10.100.0.0/24 -j ACCEPT
        # NAT for VPN clients
        iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o eno1 -m policy --pol ipsec --dir out -j ACCEPT
        iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o eno1 -j MASQUERADE
        # MSS clamping
        iptables -t mangle -A FORWARD -m policy --pol ipsec --dir in -s 10.100.0.0/24 -o eno1 -p tcp --tcp-flags SYN,RST SYN -m tcpmss --mss 1361:1536 -j TCPMSS --set-mss 1360
        # Final drops
        iptables -A INPUT -j DROP
        iptables -A FORWARD -j DROP
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
