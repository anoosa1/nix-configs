{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.anoosa.zsh.enable {
    programs = {
      starship = {
        enable = true;
        enableZshIntegration = true;

        settings = {
          add_newline = false;
          format = lib.concatStrings [
            #"$username"
            "$hostname"
            "$localip"
            "$shlvl"
            "$singularity"
            "$kubernetes"
            "$directory"
            "$vcsh"
            "$fossil_branch"
            "$git_branch"
            "$git_commit"
            "$git_state"
            "$git_metrics"
            "$git_status"
            "$hg_branch"
            "$pijul_channel"
            "$docker_context"
            "$package"
            "$c"
            "$cmake"
            "$cobol"
            "$daml"
            "$dart"
            "$deno"
            "$dotnet"
            "$elixir"
            "$elm"
            "$erlang"
            "$fennel"
            "$golang"
            "$guix_shell"
            "$haskell"
            "$haxe"
            "$helm"
            "$java"
            "$julia"
            "$kotlin"
            "$gradle"
            "$lua"
            "$nim"
            "$nodejs"
            "$ocaml"
            "$opa"
            "$perl"
            "$php"
            "$pulumi"
            "$purescript"
            "$python"
            "$raku"
            "$rlang"
            "$red"
            "$ruby"
            "$rust"
            "$scala"
            "$solidity"
            "$swift"
            "$terraform"
            "$vlang"
            "$vagrant"
            "$zig"
            "$buf"
            "$nix_shell"
            "$conda"
            "$meson"
            "$spack"
            "$memory_usage"
            "$aws"
            "$gcloud"
            "$openstack"
            "$azure"
            "$env_var"
            "$crystal"
            "$custom"
            "$sudo"
            "$cmd_duration"
            "$jobs"
            "$battery"
            "$time"
            "$status"
            "$os"
            "$container"
            "$shell"
            "$character"
          ];

          username = {
            style_user = "fg:green bold";
            style_root = "fg:red bold";
            format = "[$user]($style)";
            disabled = false;
            show_always = true;
          };

          hostname = {
            ssh_only = false;
            format = "[$hostname](fg:yellow bold) ";
            #format = "[@](fg:grey bold) [$hostname](fg:yellow bold) ";
            trim_at = ".";
            disabled = false;
          };

          character = {
            format = "$symbol ";
            success_symbol = "[i >](fg:green bold)";
            error_symbol = "[i ✗](fg:red bold)";
            vimcmd_symbol = "[n <](fg:yellow bold)";
            vimcmd_replace_one_symbol = "[r <](fg:magenta bold)";
            vimcmd_replace_symbol = "[r <](fg:magenta bold)";
            vimcmd_visual_symbol = "[v <](fg:yellow bold)";
            disabled = false;
          };

          directory = {
            read_only = "";
            truncation_length = 10;
            truncate_to_repo = true;
            style = "fg:blue bold italic";
          };

          cmd_duration = {
            min_time = 4;
            show_milliseconds = false;
            disabled = false;
            style = "fg:#F2777A bold italic";
          };

          conda = {
            symbol = "";
          };

          dart = {
            symbol = "";
          };

          git_branch = {
            symbol = "";
          };

          git_state = {
            style = "fg:#F2777A bold";
            format = "[$state( $progress_current/$progress_total) ]($style)";
            rebase = "rebase";
            merge = "merge";
            revert = "revert";
            cherry_pick = "cherry";
            bisect = "bisect";
            am = "am";
            am_or_rebase = "am/rebase";
          };

          golang = {
            symbol = "";
          };

          java = {
            symbol = "";
          };

          memory_usage = {
            symbol = "";
          };

          nix_shell = {
            symbol = "";
          };

          package = {
            symbol = "";
          };

          rust = {
            symbol = "";
          };
        };
      };
    };
  };
}
