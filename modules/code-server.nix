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
      };
    };
  };
}
