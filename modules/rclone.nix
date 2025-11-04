{
  lib,
  config,
  ...
}:
{
  options.anoosa.rclone.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable rclone";
    example = true;
  };

  config = lib.mkIf config.anoosa.rclone.enable {
    programs = {
      rclone = {
        enable = true;

        remotes = {
          astra = {
            config = {
              type = "sftp";
              host = "astra.asherif.xyz";
              use_insecure_cipher = false;
              shell_type = "unix";
              md5sum_command = "md5sum";
              sha1sum_command = "sha1sum";
            };

            secrets = {
              key_pem = "${config.xdg.configHome}/ssh/id_rsa";
            };

            mounts = {
              "/home/anas" = {
                enable = true;
                mountPoint = "${config.home.homeDirectory}/.local/media/astra";

                options = {
                  uid = 1000;
                  gid = 1000;
                  umask = 0077;
                  default-permissions = true;
                  vfs-cache-mode = "writes";
                  buffer-size = "64M";
                  multi-thread-streams = 4;
                  multi-thread-cutoff = "250M";
                };
              };

              "/home/anas/docs" = {
                enable = true;
                mountPoint = "${config.xdg.userDirs.documents}";

                options = {
                  uid = 1000;
                  gid = 1000;
                  umask = 0077;
                  default-permissions = true;
                  vfs-cache-mode = "writes";
                  buffer-size = "64M";
                  multi-thread-streams = 4;
                  multi-thread-cutoff = "250M";
                };
              };

              "/home/anas/audio" = {
                enable = true;
                mountPoint = "${config.xdg.userDirs.music}";

                options = {
                  uid = 1000;
                  gid = 1000;
                  umask = 0077;
                  default-permissions = true;
                  vfs-cache-mode = "writes";
                  buffer-size = "64M";
                  multi-thread-streams = 4;
                  multi-thread-cutoff = "250M";
                };
              };
            };
          };
        };
      };
    };
  };
}
