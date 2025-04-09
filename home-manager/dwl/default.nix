{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    ./dwl.nix
  ];

  wayland = {
    windowManager = {
      dwl = {
        enable = true;
        config = ./config.def.h;
        #patches = [
        #  (pkgs.fetchpatch {
        #    url = "https://codeberg.org/dwl/dwl-patches/raw/branch/main/patches/ipc/ipc.patch";
        #    hash = "sha256-JOncRH9DxJtN5ZzMUexB2PpGaJUxwdHbDtZUYxYQh5A=";
        #  })
        #];
      };
    };
  };
}
