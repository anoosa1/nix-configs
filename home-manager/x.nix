{ config, pkgs, ... }:

{
  xsession = {
    enable = true;
    numlock = {
      enable = true;
    };
    profileExtra = "xcompmgr&\nremaps.sh&\nsetbg.sh&";
    profilePath = ".local/etc/X11/xprofile.sh";
    scriptPath = ".local/etc/X11/xsession.sh";
    windowManager = {
      command = "/nix/store/4iwl4mh6hsjj08ch5wrvjyizd3jdq4wm-dwm-6.4/bin/dwm";
    };
  };
}
