{
  sops = {
    secrets = {
      "zitadel/master_key" = {
        owner = "zitadel";
      };

      "zitadel/steps" = {
        owner = "zitadel";
      };
    };
  };

  services = {
    nginx.virtualHosts = {
      "auth.asherif.xyz" = {
        forceSSL = true;
        enableACME = true;
        acmeRoot = null;
        locations."/" = {
          proxyPass = "http://localhost:9482";
          proxyWebsockets = true;
          extraConfig = "proxy_set_header Host $host;";
        };
      };
    };

    postgresql = {
      ensureDatabases = [ "zitadel" ];
      ensureUsers = [{
        name = "zitadel";
        ensureDBOwnership = true;
      }];
    };

    zitadel = {
      enable = true;
      masterKeyFile = "/run/secrets/zitadel/master_key";
      extraStepsPaths = [
        "/run/secrets/zitadel/steps"
      ];

      steps = {
        FirstInstance = {
          Skip = false;
          InstanceName = "asherif.xyz";
          Org = {
            Name = "asherif.xyz";

            Human = {
              UserName = "anas";
              FirstName = "Anas";
              LastName = "Sherif";
              DisplayName = "Anas";
              PasswordChangeRequired = false;
              Email = {
                Address = "anas@asherif.xyz";
                Verified = true;
              };
            };
          };
        };
      };

      settings = {
        Port = 9482;
        ExternalDomain = "auth.asherif.xyz";

        DefaultInstance = {
          DomainPolicy = {
          };

          LoginPolicy = {
            AllowRegister = false;
            ForceMFA = true;
          };
        };

        Database = {
          postgres = {
            Host = "localhost";
            Port = "5432";
            Database = "zitadel";
            MaxOpenConns = "25";
            MaxConnLifetime = "1h";
            MaxConnIdleTime = "5m";

            User = {
              Username = "zitadel";
              Password = "zitadel";
              SSL.Mode = "disable";
            };

            Admin = {
              Username = "postgres";
              Password = "postgres";
              SSL.Mode = "disable";
            };
          };
        };
      };
    };
  };
}
