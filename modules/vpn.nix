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

    ## services
    services.strongswan-swanctl = {
      enable = true;
      swanctl = {
        connections."ikev2-vpn" = {
          version = 2;
          local."0" = {
            auth = "pubkey";
            certs = [ "/run/secrets/vpn/server-cert" ];
            id = "astra.asherif.xyz";
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
          cacert = "/run/secrets/vpn/ca-cert";
        };

        pools."vpn-pool" = {
          addrs = "10.100.0.0/24";
          dns = [ "1.1.1.1" "1.0.0.1" ];
        };
      };
    };

    ## networking
    networking = {
      # Firewall — open IKE and IPsec NAT-T
      firewall.allowedUDPPorts = [ 500 4500 ];

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
