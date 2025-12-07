{
  pkgs,
  ...
}:
{
  ## environment
  environment = {
    # variables
    sessionVariables = rec {
      XDG_CACHE_HOME = "$HOME/.local/var/cache";
      XDG_CONFIG_HOME = "$HOME/.local/etc";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/var/state";
      ZDOTDIR = "$XDG_CONFIG_HOME/zsh";

      XDG_BIN_HOME = "$HOME/.local/bin";
      PATH = [
        "${XDG_BIN_HOME}"
      ];
    };

    # system packages
    systemPackages = with pkgs; [
      linux-firmware
      ffmpeg
      neofetch
    ];

    pathsToLink = [ "/share/applications" "/share/xdg-desktop-portal" ];
  };

  programs = {
    zsh = {
      enable = true;
    };
  };
}
