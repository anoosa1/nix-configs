{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.anoosa."4get" = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable 4get";
      example = true;
    };

    subdomain = lib.mkOption {
      type = lib.types.str;
      default = "search2";
      description = "Subdomain to host 4get at";
      example = "search";
    };
  };

  config = lib.mkIf config.anoosa."4get".enable {
    services = {
      nginx.virtualHosts = {
        "${config.anoosa."4get".subdomain}.${config.anoosa.domain}" = {
          root = "${pkgs."4get"}/share/4get";
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;

          locations = {
            "/" = {
              index = "index.php";
              tryFiles = "$uri $uri/ $uri.php$is_args$query_string";
            };

            "~ \\.php$" = {
              tryFiles = "$uri $uri/ $uri.php$is_args$query_string";

              extraConfig = ''
                fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
                
                fastcgi_pass unix:${config.services.phpfpm.pools."4get".socket};
                fastcgi_index index.php;
                include ${pkgs.nginx}/conf/fastcgi_params;
              '';
            };
          };
        };
      };

      phpfpm.pools."4get" = {
        user = "nginx";
        group = "nginx";

        phpPackage = pkgs.php83.withExtensions ({ all, ... }: with all; [
          apcu
          fileinfo
          curl
          gd
          mbstring
          opcache
          imagick
          zlib
          openssl
          sodium
          filter
        ]);

        settings = {
          "pm" = "dynamic";
          "pm.max_children" = 32;
          "pm.start_servers" = 2;
          "pm.min_spare_servers" = 2;
          "pm.max_spare_servers" = 4;
          "php_admin_value[apc.enabled]" = "1";
          "php_admin_value[apc.shm_size]" = "32M";
        };
      };
    };
  };
}
