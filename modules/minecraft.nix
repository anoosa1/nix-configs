{
  inputs,
  ...
}:
{
  flake.nixosModules.minecraft = { pkgs, ... }:
    let
      modpack = pkgs.fetchPackwizModpack {
        src = pkgs.fetchFromGitea { domain = "git.asherif.xyz"; owner = "anoosa"; repo = "skyfactory"; rev = "master"; sha256 = "sha256-5OLzQh3wJN4LTP9G5uGJlqoral1x1ELqddhh3LmnOiw=";};
      };
    in
    {
    imports = [
      inputs.nix-minecraft.nixosModules.minecraft-servers
    ];

    nixpkgs = {
      overlays = [ inputs.nix-minecraft.overlay ];
    };

    services = {
      minecraft-servers = {
        enable = true;
        eula = true;
        dataDir = "/var/lib/minecraft";

        servers = {
            #skyfactory = {
            #  enable = true;
            #  autoStart = true;
            #  openFirewall = true;
            #  jvmOpts = "-Xms2048M -Xmx6144M";
            #  package = pkgs.neoforgeServers.neoforge-1_20_1;

            #  whitelist = {
            #    Anoosa1 = "4f339de8-4752-4c63-8aa8-ee40d94418bd";
            #    River353 = "4bf17825-eb64-4927-ae16-e3260f782929";
            #    TrapGodGG_ = "62d9d598-95ae-4fc8-9597-4de604beb482";
            #    trxye = "a44337a9-834e-442d-8d08-470c3d690361";
            #  };

            #  serverProperties = {
            #    difficulty = 3;
            #    motd = "Anoosa's SkyFactory";
            #    pause-when-empty-seconds = 30;
            #    region-file-compression = "lz4";
            #    require-resource-pack = true;
            #    resource-pack = "https://cdn.modrinth.com/data/2YyNMled/versions/Y8mjFzcP/Dramatic%20Skys%20Demo%201.5.3.36.2.zip";
            #    resource-pack-sha1 = "483049f9e82cfaedb51748124ea92237c9c28371";
            #    server-port = 25565;
            #    simulation-distance = 16;
            #    spawn-protection = 0;
            #    view-distance = 16;
            #    white-list = true;
            #  };

            #  symlinks = {
            #    "mods" = "${modpack}/mods";
            #  };

            #  files = {
            #    "config" = "${modpack}/config";
            #  };
            #};

          hardcore = {
            enable = true;
            autoStart = true;
            openFirewall = true;
            jvmOpts = "-Xms2048M -Xmx4096M";
            package = pkgs.fabricServers.fabric-1_21_11;

            whitelist = {
              Anoosa1 = "4f339de8-4752-4c63-8aa8-ee40d94418bd";
              River353 = "4bf17825-eb64-4927-ae16-e3260f782929";
              SirNh = "2f4a7860-e75c-4cab-8810-25a36e30761d";
              TrapGodGG_ = "62d9d598-95ae-4fc8-9597-4de604beb482";
              Venusflametrap = "ee23f2df-c85e-4a09-bcf7-f4d7d32796d2";
              azi_shk786 = "da90faf2-d314-405d-a54f-6f9083e82eef";
              ghatinof2 = "59a0f2b7-f8af-49bb-8513-e818175da922";
              trxye = "a44337a9-834e-442d-8d08-470c3d690361";
            };

            serverProperties = {
              difficulty = 3;
              motd = "Anoosa's Server";
              pause-when-empty-seconds = 30;
              region-file-compression = "lz4";
              require-resource-pack = true;
              resource-pack = "https://cdn.modrinth.com/data/2YyNMled/versions/Y8mjFzcP/Dramatic%20Skys%20Demo%201.5.3.36.2.zip";
              resource-pack-sha1 = "483049f9e82cfaedb51748124ea92237c9c28371";
              server-port = 25565;
              simulation-distance = 16;
              spawn-protection = 0;
              view-distance = 16;
              white-list = true;
            };

            symlinks = {
              "config/EssentialCommands.properties" = {
                value = {
                  allow_back_on_death = true;
                  check_for_updates = false;
                  enable_anvil = true;
                  enable_bed = true;
                  enable_fly = false;
                  enable_day = false;
                  enable_night = false;
                  enable_sleep = true;
                  invuln_while_afk = true;
                  home_limit = 5;
                  rtp_radius = 50000;
                };
              };

              mods = pkgs.linkFarmFromDrvs "mods" (builtins.attrValues {
                essential_commands = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/6VdDUivB/versions/3s9XXmZa/essential_commands-0.38.6-mc1.21.11.jar"; sha512 = "3bbe9a7a63e97189308bf907057c6c766f60f799f9830a791048c604df1f994cf7cebc0de5d9e703ef9586fc7b65e8386942976529dd72522243ac7be1e3113b"; };
                fabric_api = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/i5tSkVBH/fabric-api-0.141.3%2B1.21.11.jar"; sha512 = "c20c017e23d6d2774690d0dd774cec84c16bfac5461da2d9345a1cd95eee495b1954333c421e3d1c66186284d24a433f6b0cced8021f62e0bfa617d2384d0471"; };
                ferritecore = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/uXXizFIs/versions/Ii0gP3D8/ferritecore-8.2.0-fabric.jar"; sha512 = "3210926a82eb32efd9bcebabe2f6c053daf5c4337eebc6d5bacba96d283510afbde646e7e195751de795ec70a2ea44fef77cb54bf22c8e57bb832d6217418869"; };
                krypton = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/fQEb0iXm/versions/O9LmWYR7/krypton-0.2.10.jar"; sha512 = "4dcd7228d1890ddfc78c99ff284b45f9cf40aae77ef6359308e26d06fa0d938365255696af4cc12d524c46c4886cdcd19268c165a2bf0a2835202fe857da5cab"; };
                lithium = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/qvNsoO3l/lithium-fabric-0.21.3%2Bmc1.21.11.jar"; sha512 = "2883739303f0bb602d3797cc601ed86ce6833e5ec313ddce675f3d6af3ee6a40b9b0a06dafe39d308d919669325e95c0aafd08d78c97acd976efde899c7810fd"; };
                sodium = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/AANobbMI/versions/1OWNgWVR/sodium-fabric-0.8.4%2Bmc1.21.11.jar"; sha512 = "c882e07f09ccc04b6258e79979a8e1429018de5b09da5fccea189d0a5de60ea5475f1884fc724f4d3ababc8abe730b9856d5e4864c3e418b21871dbaed21f0c3"; };
                worldedit = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/1u6JkXh5/versions/o645q0Oo/worldedit-mod-7.4.0.jar"; sha512 = "1ad3e994cd314e50e561281a77696107dbd7124fcec8e9e0c0d4043fa081840ef8087aaec99cacde6b6270ff283a8d3c7ea5c113558524468f8c58e5e13f9a4a"; };
                #securecrops = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/G89SpEyJ/versions/PfFFKOYq/securecrops-2.0.1%2B1.21.5-1.21.10.jar"; sha512 = "63a2173d67b05f6956b026fef00fc0a5f641e1ec8516feca95c9d6cfaf00a85f534f169eb187e371cf229f03c08afcca04f0f3cf0fadfd0630ab4362784fd922"; };
              });
            };
          };
        };
      };
    };
  };
}
