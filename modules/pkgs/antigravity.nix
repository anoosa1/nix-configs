# modules/pkgs/antigravity-2-0.nix
{
  perSystem = { pkgs, lib, ... }: rec {
    packages.antigravity = pkgs.stdenvNoCC.mkDerivation {
      pname = "antigravity";
      version = "2.0";

      src = pkgs.fetchurl {
        url = "https://storage.googleapis.com/antigravity-public/antigravity-hub/2.0.1-6566078776737792/linux-x64/Antigravity.tar.gz";
        sha256 = "sha256-Byfh9WlhttI0eUHyeNppzGwX3jvv6YhSSEjNFnOA6as=";
      };

      sourceRoot = ".";

      nativeBuildInputs = [ pkgs.autoPatchelfHook pkgs.makeWrapper ];

      buildInputs = [
        pkgs.alsa-lib
        pkgs.at-spi2-core
        pkgs.cairo
        pkgs.cups
        pkgs.dbus
        pkgs.expat
        pkgs.fontconfig
        pkgs.freetype
        pkgs.gdk-pixbuf
        pkgs.glib
        pkgs.gtk3
        pkgs.libGL
        pkgs.libdrm
        pkgs.libxkbcommon
        pkgs.mesa
        pkgs.nspr
        pkgs.nss
        pkgs.pango
        pkgs.stdenv.cc.cc.lib
        pkgs.systemd
        pkgs.vulkan-loader
        pkgs.libX11
        pkgs.libXcomposite
        pkgs.libXdamage
        pkgs.libXext
        pkgs.libXfixes
        pkgs.libXrandr
        pkgs.libxcb
      ];

      installPhase = ''
        runHook preInstall
        mkdir -p $out/share/antigravity
        cp -r * $out/share/antigravity

        # Create wrapper
        mkdir -p $out/bin
        makeWrapper $out/share/antigravity/Antigravity-x64/antigravity $out/bin/antigravity \
          --prefix PATH : ${lib.makeBinPath [ pkgs.xdg-utils ]} \
          --add-flags "--ozone-platform-hint=auto" \
          --add-flags "--enable-features=WaylandWindowDecorations"

        # Create desktop entry
        mkdir -p $out/share/applications
        cat > $out/share/applications/antigravity.desktop <<EOF
[Desktop Entry]
Name=Antigravity
Exec=antigravity %U
Terminal=false
Type=Application
Icon=antigravity
StartupWMClass=antigravity
Comment=Agentic development platform
Categories=Development;IDE;
EOF
        runHook postInstall
      '';

      meta = with lib; {
        description = "Core runtime engine and user interface library for Antigravity 2.0";
        homepage = "https://antigravity.google/";
        license = licenses.asl20;
        platforms = platforms.all;
        maintainers = with maintainers; [ anoosa ];
      };
    };

    packages.antigravity-fhs = pkgs.buildFHSEnv {
      name = "antigravity";
      runScript = "${packages.antigravity}/bin/antigravity";

      targetPkgs = pkgs: with pkgs; [
        glibc
        curl
        icu
        libunwind
        libuuid
        lttng-ust
        openssl
        zlib
        krb5
        git
        nodejs
        coreutils
        gnupg

        # Chromium sandboxing and runtime dependencies
        glib
        nspr
        nss
        dbus
        at-spi2-atk
        cups
        expat
        libxkbcommon
        libx11
        libxcomposite
        libxdamage
        libxcb
        libxext
        libxfixes
        libxrandr
        cairo
        pango
        alsa-lib
        libgbm
        udev
      ];

      extraBwrapArgs = [
        "--bind-try /etc/nixos/ /etc/nixos/"
        "--ro-bind-try /etc/xdg/ /etc/xdg/"
      ];

      extraInstallCommands = ''
        ln -s "${packages.antigravity}/share" "$out/"
      '';

      meta = packages.antigravity.meta // {
        description = "Wrapped variant of Antigravity 2.0 which launches in a FHS compatible environment";
      };
    };
  };
}
