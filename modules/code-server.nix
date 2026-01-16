{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.anoosa.code-server = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable code-server";
      example = true;
    };

    subdomain = lib.mkOption {
      type = lib.types.str;
      default = "code";
      description = "Subdomain to host code-server at";
      example = "code";
    };
  };

  config = lib.mkIf config.anoosa.code-server.enable {
    users = {
      users = {
        code-server = {
          homeMode = "700";

          openssh.authorizedKeys.keys = [
            "ecdsa-sha2-nistp256 aaaae2vjzhnhlxnoytitbmlzdhayntyaaaaibmlzdhayntyaaabbbp3txthu/cpty8i3avau/wsnd4/3fgxerbjnvqlmlwlsmu9nplwenowaowu2y7xnbxvdd0ewmeeoog0kbtmolso="
            "ssh-rsa aaaab3nzac1yc2eaaaadaqabaaacaqdesspc9jtsl2rrpuiknuoz9wed5oa9m5jxficnyjnlbjfo/uot4plvt+srymm96xe3fd8lznrs9xgrr2zn5sodr8tewq9vm+qsrt5py5xljlqyrc2kbr8h040lf86ztvixfqozchbv0yttnnnjioz1dzna1rr+t9a6logsdndrz4eyaybswba6zqv4bcysfct1o9tbpwtny4st1/6mengrp/qvz8mrsfaw3ripc65yxfx+ydb96oz/h0h7vdbtjwa1kxhtgnt9lfiwu5tfdok2lgkjmzxsglwz7i7khgp6pxssn4er+b+mtipqvnyfjcxyniioo1vgen8jz8o7nrtnwqdx8veb0mg3ag88eysroxo1bau5vpwvie/rj5njqepn1ih1kx0hisnyn9ngqrg9gn0jx4rqe7nxl5oqias3iodfflnlhpyi5aqsisp8r4omezjfzq0k8t8o1u++foy9mjenrinhykm0sjak22cdtg5wrezcbek9x7cbmu2korwl5wj+ydgehdmbbu/1cx5f7czvfxr2gmph2brpnnee991tz8yl4xk0xuj7wqaoo0wqsoma/qjx6eirck17i25tuzbnnh/alxqb211kgo4dnwylxhckl+g48kwd1kwkdaxf427m6ldbthjfvrg0cbla9vxffap5qjtplfodthbaww== anas"
          ];
        };
      };
    };

    services = {
      nginx.virtualHosts = {
        "${config.anoosa.code-server.subdomain}.${config.anoosa.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          locations."/" = {
            proxyPass = "http://unix:/run/code-server/code-server.sock:/";
            proxyWebsockets = true;
            extraConfig = "proxy_pass_header Authorization;";
          };
        };
      };

      code-server = {
        enable = true;
        userDataDir = "/home/code-server";
        socketMode = "777";
        socket = "/run/code-server/code-server.sock";
        hashedPassword = "$argon2i$v=19$m=4096,t=3,p=1$MkI1SVNweE9YSFZwcmhLSmpVU0VwdnlpcE0wPQ$d7GsnTEdz2npQoZqTgjodvAGz9aPMNsRorbbL+421JY";
        proxyDomain = "code.asherif.xyz";
        disableWorkspaceTrust = true;
        disableUpdateCheck = true;
        disableTelemetry = true;
        disableGettingStartedOverride = true;

        package = pkgs.vscode-with-extensions.override {
          vscode = pkgs.code-server;
          vscodeExtensions = with pkgs.vscode-extensions; [
            asvetliakov.vscode-neovim
            bbenoist.nix
            Google.gemini-cli-vscode-ide-companion
            jdinhlife.gruvbox
            llvm-vs-code-extensions.vscode-clangd
            ms-dotnettools.csharp
            ms-python.python
          ];
        };

        extraPackages = [
          pkgs.gemini-cli
          pkgs.neovim
        ];
      };
    };
  };
}
