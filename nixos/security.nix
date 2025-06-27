{
  ## security
  security = {
    pam = {
      services = {
        swaylock = {};

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
          gnupg = {
            enable = true;
            storeOnly = true;
            noAutostart = true;
          };
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
