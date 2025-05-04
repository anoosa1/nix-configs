{
  ...
}:
{
  ## security
  security = {
    pam = {
      services = {
        waylock = {};

        su = {
          requireWheel = true;
        };

        system-login = {
          failDelay = {
            enable = true;
            delay = 4000000;
          };
        };

        greetd = {
          enableGnomeKeyring = true;
        };
      };
    };

    # polkit
    polkit = {
      enable = true;
    };

    # rtkit
    rtkit = {
      enable = true;
    };
  };
}
