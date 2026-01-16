{
  pkgs,
  ...
}:
{
  home-manager = {
    users = {
      anas = {
        imports = [
          ./accounts
          ./home
          ./services
          ./stylix.nix
        ];
      };
    };
  };

  users = {
    users = {
      anas = {
        isNormalUser = true;
        group = "anas";
        description = "Anas";
        extraGroups = [ "wheel" "audio" "adbusers" "transmission" "immich" "kvm" "minecraft" "open-webui" ];
        shell = pkgs.zsh;
        openssh.authorizedKeys.keys = [
          "ecdsa-sha2-nistp256 aaaae2vjzhnhlxnoytitbmlzdhayntyaaaaibmlzdhayntyaaabbbp3txthu/cpty8i3avau/wsnd4/3fgxerbjnvqlmlwlsmu9nplwenowaowu2y7xnbxvdd0ewmeeoog0kbtmolso="
          "ssh-rsa aaaab3nzac1yc2eaaaadaqabaaacaqdesspc9jtsl2rrpuiknuoz9wed5oa9m5jxficnyjnlbjfo/uot4plvt+srymm96xe3fd8lznrs9xgrr2zn5sodr8tewq9vm+qsrt5py5xljlqyrc2kbr8h040lf86ztvixfqozchbv0yttnnnjioz1dzna1rr+t9a6logsdndrz4eyaybswba6zqv4bcysfct1o9tbpwtny4st1/6mengrp/qvz8mrsfaw3ripc65yxfx+ydb96oz/h0h7vdbtjwa1kxhtgnt9lfiwu5tfdok2lgkjmzxsglwz7i7khgp6pxssn4er+b+mtipqvnyfjcxyniioo1vgen8jz8o7nrtnwqdx8veb0mg3ag88eysroxo1bau5vpwvie/rj5njqepn1ih1kx0hisnyn9ngqrg9gn0jx4rqe7nxl5oqias3iodfflnlhpyi5aqsisp8r4omezjfzq0k8t8o1u++foy9mjenrinhykm0sjak22cdtg5wrezcbek9x7cbmu2korwl5wj+ydgehdmbbu/1cx5f7czvfxr2gmph2brpnnee991tz8yl4xk0xuj7wqaoo0wqsoma/qjx6eirck17i25tuzbnnh/alxqb211kgo4dnwylxhckl+g48kwd1kwkdaxf427m6ldbthjfvrg0cbla9vxffap5qjtplfodthbaww== anas"
        ];
      };
    };

    groups = {
      anas = {
        gid = 1000;
      };
    };
  };
}
