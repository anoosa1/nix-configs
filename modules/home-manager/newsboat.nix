{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.anoosa.newsboat.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable newsboat";
    example = true;
  };

  config = lib.mkIf config.anoosa.newsboat.enable {
    programs = {
      newsboat = {
        enable = true;
        autoReload = true;

        extraConfig = ''
          urls-source "ocnews"
          ocnews-url "https://hub.asherif.xyz"
          ocnews-login "anas"
          ocnews-passwordeval "pa.sh s newsboat"

          #show-read-feeds no
          #external-url-viewer "urlscan -dc -r '${pkgs.handler}/bin/handler.sh {}'"
          browser "${pkgs.handler}/bin/handler.sh --menu"
          
          bind-key j down
          bind-key k up
          bind-key j next articlelist
          bind-key k prev articlelist
          bind-key J next-feed articlelist
          bind-key K prev-feed articlelist
          bind-key G end
          bind-key g home
          bind-key d pagedown
          bind-key u pageup
          bind-key l open
          bind-key h quit
          bind-key a toggle-article-read
          bind-key n next-unread
          bind-key N prev-unread
          bind-key D pb-download
          bind-key U show-urls
          bind-key x pb-delete
          
          color listnormal cyan default
          color listfocus black yellow standout bold
          color listnormal_unread blue default
          color listfocus_unread yellow default bold
          color info red black bold
          color article white default bold
          
          macro , open-in-browser
          macro t set browser "${pkgs.handler}/handler.sh --qndl" ; open-in-browser ; set browser ${pkgs.handler}/handler.sh
          macro a set browser "tsp yt-dlp --embed-metadata -xic -f bestaudio/best --restrict-filenames" ; open-in-browser ; set browser ${pkgs.handler}/handler.sh
          macro v set browser "setsid -f mpv" ; open-in-browser ; set browser ${pkgs.handler}/handler.sh
          macro w set browser "elinks" ; open-in-browser ; set browser ${pkgs.handler}/handler.sh
          macro d set browser "${pkgs.handler}/handler.sh --menu" ; open-in-browser ; set browser ${pkgs.handler}/handler.sh
          macro c set browser "echo %u | xclip -r -sel c" ; open-in-browser ; set browser ${pkgs.handler}/handler.sh
          macro C set browser "youtube-viewer --comments=%u" ; open-in-browser ; set browser ${pkgs.handler}/handler.sh
          macro p set browser "peertubetorrent %u 1080" ; open-in-browser ; set browser ${pkgs.handler}/handler.sh
          
          highlight all "---.*---" yellow
          highlight feedlist ".*(0/0))" black
          highlight article "(^Feed:.*|^Title:.*|^Author:.*)" cyan default bold
          highlight article "(^Link:.*|^Date:.*)" default default
          highlight article "https?://[^ ]+" green default
          highlight article "^(Title):.*$" blue default
          highlight article "\\[[0-9][0-9]*\\]" magenta default bold
          highlight article "\\[image\\ [0-9]+\\]" green default bold
          highlight article "\\[embedded flash: [0-9][0-9]*\\]" green default bold
          highlight article ":.*\\(link\\)$" cyan default
          highlight article ":.*\\(image\\)$" blue default
          highlight article ":.*\\(embedded flash\\)$" magenta default
        '';
      };
    };
  };
}
