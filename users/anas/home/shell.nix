{
  home = {
    shell = {
      enableZshIntegration = true;
    };

    shellAliases = {
      mount = "sudo mount";
      umount = "sudo umount";

      cp = "cp -iv";
      mv = "mv -iv";
      rm = "rm -vI";
      rsync = "rsync -vrPlu";
      mkd = "mkdir -pv";
      yt = "yt-dlp --embed-metadata -i";
      yta = "yt -x -f bestaudio/best";
      ytt = "yt --skip-download --write-thumbnail";
      ffmpeg = "ffmpeg -hide_banner";

      ls = "eza -a --icons --color=always --group-directories-first";
      ll = "eza -lahHmgb --icons --color=always --group-directories-first";
      lt = "eza -aT --icons --color=always --group-directories-first";
      grep = "grep --color=auto";
      diff = "diff --color=auto";
      ccat = "highlight --out-format=ansi";
      ip = "ip -color=auto";

      s = "systemctl";
      j = "journalctl";
      u = "sudo nixos-rebuild switch --flake .";
      "..." = "cd ../..";

      magit = "nvim -c MagitOnly";
      weath = "less -S $XDG_CACHE_HOME/weatherreport";
      se = "se.sh";
      abook = "abook -C .local/etc/abook/abook.conf -f .local/share/abook/addressook";

      z = "zathura";
      e = "nvim";
      k = "pkill";
      g = "git";

      astra = "ssh astra";
    };
  };
}
