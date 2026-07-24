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
            hash = "sha256-lvbBgaMPSVBgeDnchNQqNUslDYoCMbCYtZt7xpw1HEg="; # Replace with your actual hash
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
            vulkan-loader # Added for Vulkan backend support
            
            # X11 client libs needed for UI / plugins
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

          # Ignore optional/vendor-specific libraries loaded dynamically at runtime
          autoPatchelfIgnoreMissingDeps = [
            "libamdhip64.so.7"
            "libze_loader.so.1"
            "libcuda.so.1"
            "libsteam_api.so"
            "libGLES_CM.so.1"
          ];

          installPhase = ''
            mkdir -p $out/bin $out/share
            cp -r * $out/
            
            # Wrap the main executable to inject NixOS system GPU drivers (CUDA/OptiX/Vulkan)
            makeWrapper $out/blender $out/bin/blender \
              --prefix LD_LIBRARY_PATH : "/run/opengl-driver/lib"
          '';

          postFixup = ''
            # Patch binaries with runpath to system graphics drivers
            addDriverRunpath $out/bin/blender
          '';
        })
      ];
    };
}
