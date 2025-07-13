{
  pkgs,
  ...
}:

{
  services = {
    nginx.virtualHosts = {
      "code.localhost" = {
   #     forceSSL = true;
   #     enableACME = true;
        locations."/" = {
          proxyPass = "http://localhost:4444";
          proxyWebsockets = true;
          extraConfig = "proxy_pass_header Authorization;";
        };
      };
    };
    code-server = {
      enable = true;
      package = pkgs.vscode-with-extensions.override {
        vscode = pkgs.code-server;
        vscodeExtensions = with pkgs.vscode-extensions; [
          bbenoist.nix
        ];
      };

      host = "code.localhost";
      proxyDomain = "code.localhost";
      disableTelemetry = true;
    };
  };
}
