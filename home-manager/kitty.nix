{ config, pkgs, ... }:

{
  programs = {
    kitty = {
      enable = true;
      shellIntegration = {
        enableZshIntegration = true;
      };
    };
  };
}
