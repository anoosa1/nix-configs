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

      dust
      dua
      eva
      eza
      fd
      gitui
      libsixel
      localsend
      mpv
      neovim
      komikku
      prismlauncher
      nsxiv
      playerctl
      pulsemixer
      ripgrep
      rmpc
      rsync
      rustmission
      scripts.se
      simplex-chat-desktop
      steamguard-cli
      umu-launcher
      yt-dlp
      zathura
    ];
  };
}
