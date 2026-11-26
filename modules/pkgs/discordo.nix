# modules/pkgs/discordo.nix
#
# nixpkgs' discordo predates upstream voice chat, so build a newer commit.
# Voice uses miniaudio (malgo), which dlopen()s libpulse/libasound at runtime.
{
  perSystem = { pkgs, lib, ... }: {
    packages.discordo = pkgs.buildGoModule {
      pname = "discordo";
      version = "0-unstable-2026-11-08";

      src = pkgs.fetchFromGitHub {
        owner = "ayn2op";
        repo = "discordo";
        rev = "97c7a7837b82e64d1c035c60a3bb18e5c4210641";
        hash = "sha256-APX+Sn/sZCe1Z1oxpFmTIcYhj5Rbos3whITIXw/oLPM=";
      };

      vendorHash = "sha256-g+ZCuYtDyJ/D/rOdeqMtjZnIVlsRFN/s8M8WBlSAcK4=";

      env.CGO_ENABLED = 1;

      ldflags = [
        "-s"
      ];

      nativeBuildInputs = [
        pkgs.makeWrapper
      ];

      buildInputs = [
        pkgs.libx11
      ];

      postInstall = ''
        wrapProgram $out/bin/discordo \
          --prefix PATH : "${lib.makeBinPath [ pkgs.wl-clipboard ]}" \
          --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ pkgs.libpulseaudio pkgs.alsa-lib pkgs.pipewire ]}"
      '';

      meta = with lib; {
        description = "Lightweight, secure, and feature-rich Discord terminal client (with voice chat)";
        homepage = "https://github.com/ayn2op/discordo";
        license = licenses.gpl3Plus;
        platforms = platforms.linux;
        mainProgram = "discordo";
      };
    };
  };
}
