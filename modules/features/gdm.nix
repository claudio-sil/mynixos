{ self, inputs, ... }: {
  flake.nixosModules.gdm = { pkgs, ... }: {
    services.xserver.enable = true;
    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome.enable = true;  # provides the greeter
    services.gnome.core-apps.enable = false;       # don't install GNOME apps
    services.gnome.core-developer-tools.enable = false;
    services.gnome.games.enable = false;
    services.displayManager.gdm.settings = {
      daemon = {
        WaylandEnable = true;
      };
    };
  };
}




##################################
#{ self, inputs, ... }: {
#  flake.nixosModules.gdm = { ... }: {
#    services.xserver.enable = true;
#    services.displayManager.gdm.enable = true;
#    services.displayManager.gdm.settings = {
#      daemon = {
#        WaylandEnable = true;
#      };
#    };
#  };
#}
