{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
{
  options.anoosa.copyparty = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable copyparty";
      example = true;
    };

    subdomain = lib.mkOption {
      type = lib.types.str;
      default = "files";
      description = "Subdomain to host copyparty at";
      example = "files";
    };
  };

  config = lib.mkIf config.anoosa.copyparty.enable {
    nixpkgs = {
      overlays = [ inputs.copyparty.overlays.default ];
    };

    sops = {
      secrets = {
        "anas/password" = {
          owner = "copyparty";
        };
      };
    };

    services = {
      nginx.virtualHosts = {
        "${config.anoosa.copyparty.subdomain}.${config.anoosa.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;

          locations = {
            "/" = {
              proxyPass = "http://localhost:3211";
              proxyWebsockets = true;

              extraConfig = ''
                proxy_set_header Host $host;
                auth_request     /outpost.goauthentik.io/auth/nginx;
                error_page       401 = @goauthentik_proxy_signin;
                auth_request_set $auth_cookie $upstream_http_set_cookie;
                add_header       Set-Cookie $auth_cookie;
                auth_request_set $authentik_username $upstream_http_x_authentik_username;
                auth_request_set $authentik_groups $upstream_http_x_authentik_groups;
                proxy_set_header X-authentik-username $authentik_username;
                proxy_set_header X-authentik-groups $authentik_groups;
              '';
            };

            "/outpost.goauthentik.io" = {
              proxyPass = "https://10.0.0.2:9443/outpost.goauthentik.io";
              proxyWebsockets = true;

              extraConfig = ''
                proxy_set_header        Host $host;
                proxy_set_header        X-Original-URL $scheme://$http_host$request_uri;
                add_header              Set-Cookie $auth_cookie;
                auth_request_set        $auth_cookie $upstream_http_set_cookie;
                proxy_pass_request_body off;
                proxy_set_header        Content-Length "";
              '';
            };

            "@goauthentik_proxy_signin" = {
              extraConfig = ''
                internal;
                add_header Set-Cookie $auth_cookie;
                return 302 /outpost.goauthentik.io/start?rd=$scheme://$http_host$request_uri;
              '';
            };
          };
        };
      };

      copyparty = {
        enable = true;
        openFilesLimit = 8192;

        settings = {
          i = "0.0.0.0";
          p = [ 3211 ];
          idp-h-usr = "X-authentik-username";
          idp-h-grp = "X-authentik-groups";
          xff-src = "127.0.0.1";
          xff-hdr = "x-forwarded-for";
        };

        accounts = {
          anas = {
            passwordFile = "/run/secrets/anas/password";
          };
        };

        volumes = {
          "/" = {
            path = "/export/anas";

            access = {
              rw = [ "anas" ];
            };

            flags = {
              fk = 4;
              scan = 60;
              e2d = true;
              d2t = true;
              nohash = "\\.iso$";
            };
          };
        };
      };
    };
  };
}
