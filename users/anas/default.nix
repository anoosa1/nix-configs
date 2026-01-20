{
  pkgs,
  ...
}:
{
  home-manager = {
    users = {
      anas = {
        imports = [
          ./accounts
          ./home
          ./services
          ./stylix.nix
        ];
      };
    };
  };

  users = {
    users = {
      anas = {
        isNormalUser = true;
        group = "anas";
        description = "Anas";
        extraGroups = [ "wheel" "audio" "adbusers" "transmission" "immich" "kvm" "minecraft" "open-webui" ];
        shell = pkgs.zsh;

        openssh = {
          authorizedPrincipals = [
            "anas@astra"
            "anas@aurora"
            "anas@apollo"
          ];

          authorizedKeys = {
            keys = [
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHhK2hN/aKRr12GA6dklSQbL+jG5iQ9OuvXzprvzfGc8 anas@apollo"
            ];
          };
        };
      };
    };

    groups = {
      anas = {
        gid = 1000;
      };
    };
  };
}
