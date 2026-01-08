{
  pkgs,
  ...
}:
{
  home = {
    packages = with pkgs; [
      anki

      bat
      bat-extras.batdiff
      bat-extras.batgrep
      bat-extras.batman
      bat-extras.prettybat
      bluetui
      brave

      dua
      dust

      eva
      eza

      fd

      gitui

      kitty

      libsixel
      localsend

      mpv

      neovim
      nsxiv

      playerctl
      prismlauncher
      pulsemixer

      ripgrep
      rmpc
      rsync
      rustmission

      se
      simplex-chat-desktop
      steamguard-cli

      umu-launcher
      yt-dlp
      zathura
    ];
  };
}
