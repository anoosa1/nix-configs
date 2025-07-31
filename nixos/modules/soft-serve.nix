{
  lib,
  config,
  ...
}:
{
  options.anoosa.soft-serve.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable soft-serve";
    example = true;
  };

  config = lib.mkIf config.anoosa.soft-serve.enable {
    services = {
      soft-serve = {
        enable = true;

        settings = {
          name = config.anoosa.domain;
          log_format = "text";
          stats.listen_addr = ":23233";

          ssh = {
            listen_addr = ":23231";
            public_url = "ssh://${config.anoosa.domain}:23231";
            max_timeout = 30;
            idle_timeout = 120;
          };

          initial_admin_keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHhK2hN/aKRr12GA6dklSQbL+jG5iQ9OuvXzprvzfGc8"
          ];
        };
      };
    };
  };
}
