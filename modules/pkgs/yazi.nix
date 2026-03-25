# modules/pkgs/yazi.nix
{
  inputs,
  ...
}:
{
  flake.wrappers.yazi = {
    imports = [ inputs.wrappers.lib.wrapperModules.yazi ];

    settings = {
      keymap = {
        mgr = {
          prepend_keymap = [
            {
              on   = "<C-s>";
              run  = "hidden toggle";
              desc = "Toggle hidden with `Ctrl + s`";
            }
          ];
        };
      };
    };
  };
}
