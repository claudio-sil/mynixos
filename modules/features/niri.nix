{ self, inputs, ... }: {

  flake.nixosModules.niri = { pkgs, lib, ... }: {
    programs.niri = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.myNiri;
    };
    services.displayManager.sessionPackages = [ 
      self.packages.${pkgs.stdenv.hostPlatform.system}.myNiri 
    ];
  };

  perSystem = { pkgs, lib, self', ... }: {
    
    packages.myNiri = inputs.wrapper-modules.wrappers.niri.wrap {
      inherit pkgs;
      settings = {
        # Tell Wayland clients to disable client-side title bars / decorations
        prefer-no-csd = true;

        spawn-at-startup = [
          (lib.getExe self'.packages.myNoctalia)
          "udiskie"
        ];

        outputs."DP-1" = {
          mode = "1920x1080@60.000";
          position = _: { props = { x = 0; y = 0; }; };
          scale = 1.0;
        };
        outputs."HDMI-A-1" = {
          mode = "1920x1080@60.000";
          position = _: { props = { x = 1920; y = 0; }; };
          scale = 1.0;
        };

        xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

        input = {
          # focus-follows-mouse expects a property 'enable', not a child node
          focus-follows-mouse = _: {};

          keyboard = {
            repeat-delay = 300;
            repeat-rate = 25;
          };
        };

        layout.gaps = 5;

        workspaces = {
          "1" = { open-on-output = "DP-1"; };
          "2" = { open-on-output = "HDMI-A-1"; };
          "blender" = { open-on-output = "DP-1"; };
        };

        binds = {
          "Mod+Return".spawn-sh = lib.getExe pkgs.alacritty;
          "Mod+Q".close-window = _: {};
          "Mod+S".spawn-sh = "${lib.getExe self'.packages.myNoctalia} ipc call launcher toggle";
          "Mod+B".spawn-sh = lib.getExe pkgs.firefox;
          "Mod+D".spawn-sh = "discord";
          "Mod+Shift+B".spawn-sh = "blender";

          # Navigation binds
          "Mod+H".focus-column-left = _: {};
          "Mod+L".focus-column-right = _: {};
          "Mod+K".focus-window-up = _: {};
          "Mod+J".focus-window-down = _: {};

          "Mod+Shift+H".move-column-left = _: {};
          "Mod+Shift+L".move-column-right = _: {};
          "Mod+Shift+K".move-window-up = _: {};
          "Mod+Shift+J".move-window-down = _: {};

          "Mod+Ctrl+Right".set-column-width = "+10%";         
          "Mod+Ctrl+Left".set-column-width = "-10%";
          "Mod+Ctrl+Up".set-window-height = "+10%";
          "Mod+Ctrl+Down".set-window-height = "-10%";

          # Quick Toggle for Fullscreen/Maximize
          "Mod+F".maximize-column = _: {};
          "Mod+Shift+F".fullscreen-window = _: {};
          "Mod+R".switch-preset-column-width = _: {};

          # File Managers
          "Mod+E".spawn-sh = "dolphin";
          "Mod+Y".spawn-sh = "${lib.getExe pkgs.alacritty} -e yazi";

          # Media controllers keys
          "XF86AudioPlay".spawn-sh = "${lib.getExe pkgs.playerctl} play-pause";
          "XF86AudioPrev".spawn-sh = "${lib.getExe pkgs.playerctl} previous";
          "XF86AudioNext".spawn-sh = "${lib.getExe pkgs.playerctl} next";
          "XF86AudioRaiseVolume".spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
          "XF86AudioLowerVolume".spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
          "XF86AudioStop".spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        };
        
##################################################################33
window-rules = [
          {
            matches = [{ app-id = "firefox"; }];
            default-column-width = { proportion = 0.5; };
          }
          {
            # Match the main Blender window
            matches = [ 
              { app-id = "Blender"; }
              { app-id = "blender"; }
              { app-id = "org.blender.Blender"; }
            ];

            # Emit: exclude title="Preferences|Render|File View"
            exclude = _: { props = { title = "Preferences|Render|File View"; }; };

            open-on-workspace = "blender";
            open-fullscreen = true;
          }
  
          # Floating rules for secondary popups
          {
            matches = [
              { app-id = "Blender"; title = "Preferences"; }
              { app-id = "Blender"; title = "Render"; }
              { app-id = "Blender"; title = "File View"; }
              { app-id = "blender"; title = "Preferences"; }
              { app-id = "blender"; title = "Render"; }
              { app-id = "blender"; title = "File View"; }
            ];
            open-floating = true;
          }
        ];
##################################################################3
      };
    }; # <--- Semicolon added here!

  };
}
