{
  config,
  pkgs,
  ...
}:

{
  users.users.git = {
    isSystemUser = true;
    group = "git";
    home = "/var/lib/git";
    description = "Anas";
    createHome = true;
    shell = "${pkgs.git}/bin/git-shell";
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDEsspc9jtsL2rrPUiKnuOZ9WEd5OA9M5JXfICnyJnLbJFo/uoT4pLvT+SryMm96XE3FD8LznRS9XGRR2Zn5sOdr8tEwq9vM+qSrt5pY5xLjlQYRc2KBR8H040lf86ztvIxFqozCHbv0yTtnnnjiOZ1DZNA1Rr+t9a6LoGsdNdrZ4eYAyBSwBA6zqV4BcysFCT1O9tbpwTNY4St1/6MenGRp/QVZ8mrsfAW3RiPC65YXfX+Ydb96OZ/H0h7vdBTJwA1kXHTGNt9Lfiwu5TFDOK2LgkjmZXsGlWz7I7kHGP6pXssn4Er+b+MTiPqvNyfJcXYNIIoo1vgEn8Jz8o7nrTnWQdx8veB0mg3ag88eysrOXo1bau5vPWViE/Rj5NjQepn1IH1Kx0HIsNYn9ngqRG9gn0Jx4RQe7NxL5oqIaS3iodfFLnLHPyI5AQSISP8R4omEZjFZQ0K8T8o1u++FOY9mJeNRiNHykm0SjAk22cDtg5WrEzcBeK9x7CBmU2koRwL5wJ+yDgEHDmBBu/1cX5F7CzvfxR2GMph2BRpnNeE991Tz8YL4Xk0xUJ7WQaOO0WqSoMa/QJx6EiRcK17i25TUZbnNH/ALxQB211KgO4dnwyLXhcKl+G48KwD1kwKdAxF427m6LDBtHJFvRG0cBlA9VxfFap5QJTplfODthBaWw== anas@waifu.club"
    ];
  };

  users.groups.git = {};

  services = {
    cgit.cgit = {
      enable = true;
      user = "git";
      group = "git";
      package = pkgs.cgit-pink;
      settings = {
        enable-follow-links = true;
        logo = "";
        favicon = "";
        source-filter = "${pkgs.cgit-pink}/lib/cgit/filters/syntax-highlighting.py";
        about-filter = "${pkgs.cgit-pink}/lib/cgit/filters/about-formatting.sh";
        root-title = "Anoosa's Git Repository";
        root-desc = "A web interface to Anoosa's git repositories, powered by Cgit";
      };
      scanPath = "/var/lib/git";
      nginx.virtualHost = "git.localhost";
    };
    openssh = {
      extraConfig = ''
        Match user git
          AllowTcpForwarding no
          AllowAgentForwarding no
          PermitTTY no
          X11Forwarding no
      '';
    };
  };
}

