{
  pkgs,
  ...
}:
{
  home = {
    packages = with pkgs; [
      anki
      bluetui
      brave
      du-dust
      dua
      eva
      eza
      fd
      gitui
      libsixel
      localsend
      mpv
      neovim
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
