{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.nix-minecraft.nixosModules.minecraft-servers
  ];

  services = {
    minecraft-servers = {
      enable = true;
      eula = true;
      openFirewall = true;

      servers.vanilla = {
        enable = true;
        jvmOpts = "-Xmx4G -Xms2G";
        package = pkgs.paper-server;

        serverProperties = {
          server-port = 4319;
          difficulty = 3;
          gamemode = 0;
          max-players = 10;
          allow-cheats = true;
          online-mode = false;
          motd = "Anoosa";
        };

        #symlinks = {
        #    plugins = pkgs.linkFarmFromDrvs "plugins" (builtins.attrValues {
        #      simple-tpa = pkgs.fetchurl { url = "https://www.spigotmc.org/resources/simple-tpa.64270/download?version=599814"; sha256 = "sha256-LkKJmwNZvVw7i2VE3VWWii+O4NLmJY2CVSuDacGhsVQ="; };
        #  });
        #};
      };
    };
  };
}
