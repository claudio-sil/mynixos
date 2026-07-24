{ self, inputs, ... }: {
  flake.nixosModules.blender = { pkgs, ... }: 
    let
      blenderVersion = "5.2.0";
      blenderMajor = "5.2";
    in {
      nixpkgs.config.allowUnfree = true; 

      environment.systemPackages = [
        (pkgs.stdenv.mkDerivation {
          pname = "blender";
          version = blenderVersion;

          src = pkgs.fetchurl {
            url = "https://download.blender.org/release/Blender${blenderMajor}/blender-${blenderVersion}-linux-x64.tar.xz";
            hash = "sha256-lvbBgaMPSVBgeDnchNQqNUslDYoCMbCYtZt7xpw1HEg="; # Keep your existing hash
          };

          nativeBuildInputs = [ 
            pkgs.autoPatchelfHook 
            pkgs.addDriverRunpath
            pkgs.makeWrapper
          ];

          buildInputs = with pkgs; [
            stdenv.cc.cc.lib
            libGL
            libxkbcommon
            fontconfig
            freetype
            wayland
            alsa-lib
            zlib
            dbus
            udev
            libdrm
            libXt
            pulseaudio
            jack2
            ncurses
            vulkan-loader
            
            libx11
            libxext
            libxrender
            libxi
            libxxf86vm
            libxfixes
            libxcursor
            libxinerama
            libxrandr
            libICE
            libSM
          ];

          autoPatchelfIgnoreMissingDeps = [
            "libamdhip64.so.7"
            "libze_loader.so.1"
            "libcuda.so.1"
            "libsteam_api.so"
            "libGLES_CM.so.1"
          ];

          installPhase = ''
            mkdir -p $out/bin $out/share/applications $out/share/icons/hicolor/scalable/apps $out/share/icons/hicolor/48x48/apps
            
            # Copy all blender files to derivation root
            cp -r * $out/
            
            # Executable wrapper
            makeWrapper $out/blender $out/bin/blender \
              --prefix LD_LIBRARY_PATH : "/run/opengl-driver/lib"

            # Install Desktop launcher entry
            if [ -f "$out/blender.desktop" ]; then
              cp $out/blender.desktop $out/share/applications/blender.desktop
              substituteInPlace $out/share/applications/blender.desktop \
                --replace "Exec=blender" "Exec=$out/bin/blender" \
                --replace "Icon=blender" "Icon=$out/share/icons/hicolor/scalable/apps/blender.svg"
            fi

            # Copy Icons so launchers can render the app icon
            if [ -f "$out/blender.svg" ]; then
              cp $out/blender.svg $out/share/icons/hicolor/scalable/apps/blender.svg
            fi
          '';

          postFixup = ''
            addDriverRunpath $out/bin/blender
          '';
        })
      ];
    };
}
