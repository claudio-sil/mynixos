{ self, inputs, ... }: {

  flake.nixosModules.niriMictlan = { pkgs, ... }: {
    programs.niri = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.myNiriMictlan;
    };
    services.displayManager.sessionPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.myNiriMictlan
    ];
  };

  flake.nixosModules.niriDuat = { pkgs, ... }: {
    programs.niri = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.myNiriDuat;
    };
    services.displayManager.sessionPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.myNiriDuat
    ];
  };

  perSystem = { pkgs, lib, self', ... }:
    let
      # Everything that's the SAME regardless of host.
      # `outputs` and `workspaces` are intentionally left out here —
      # each host's package below supplies its own. `noctaliaPkg` is
      # also per-host since noctalia.nix now builds a separate package
      # (and settings JSON) for each machine.
      mkBaseSettings = noctaliaPkg: {
        prefer-no-csd = true;

        spawn-at-startup = [
          (lib.getExe noctaliaPkg)
          "udiskie"
        ];

        xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

        input = {
          focus-follows-mouse = _: {};
          keyboard = {
            repeat-delay = 300;
            repeat-rate = 25;
          };
        };

        layout.gaps = 5;

        binds = {
          "Mod+Return".spawn-sh = lib.getExe pkgs.alacritty;
          "Mod+Q".close-window = _: {};
          "Mod+S".spawn-sh = "${lib.getExe noctaliaPkg} ipc call launcher toggle";
          "Mod+B".spawn-sh = lib.getExe pkgs.firefox;
          "Mod+D".spawn-sh = "discord";
          "Mod+Shift+B".spawn-sh = "blender";

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

          "Mod+F".maximize-column = _: {};
          "Mod+Shift+F".fullscreen-window = _: {};
          "Mod+R".switch-preset-column-width = _: {};

          "Mod+E".spawn-sh = "dolphin";
          "Mod+Y".spawn-sh = "${lib.getExe pkgs.alacritty} -e yazi";

          "XF86AudioPlay".spawn-sh = "${lib.getExe pkgs.playerctl} play-pause";
          "XF86AudioPrev".spawn-sh = "${lib.getExe pkgs.playerctl} previous";
          "XF86AudioNext".spawn-sh = "${lib.getExe pkgs.playerctl} next";
          "XF86AudioRaiseVolume".spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
          "XF86AudioLowerVolume".spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
          "XF86AudioStop".spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        };

        window-rules = [
          {
            matches = [{ app-id = "firefox"; }];
            default-column-width = { proportion = 0.5; };
          }
          {
            matches = [
              { app-id = "Blender"; }
              { app-id = "blender"; }
              { app-id = "org.blender.Blender"; }
            ];
            exclude = _: { props = { title = "Preferences|Render|File View"; }; };
            open-on-workspace = "blender";
            open-fullscreen = true;
          }
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
      };

      mkNiri = { noctaliaPkg, hostSettings }: inputs.wrapper-modules.wrappers.niri.wrap {
        inherit pkgs;
        settings = lib.recursiveUpdate (mkBaseSettings noctaliaPkg) hostSettings;
      };
    in
    {
      packages.myNiriMictlan = mkNiri {
        noctaliaPkg = self'.packages.myNoctaliaMictlan;
        hostSettings = {
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
          workspaces = {
            "1" = { open-on-output = "DP-1"; };
            "2" = { open-on-output = "HDMI-A-1"; };
            "blender" = { open-on-output = "DP-1"; };
          };
        };
      };

      # duat: single built-in laptop panel, no fixed output/workspace
      # pinning needed — adjust the output name below to match what
      # `niri msg outputs` reports on duat (commonly eDP-1).
      packages.myNiriDuat = mkNiri {
        noctaliaPkg = self'.packages.myNoctaliaDuat;
        hostSettings = {
          workspaces = {
            "1" = {};
            "2" = {};
            "blender" = {};
          };
        };
      };
    };
}
