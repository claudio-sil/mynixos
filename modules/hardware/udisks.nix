{ self, inputs, ... }: {
  flake.nixosModules.udisks = { pkgs, ... }: {
    services.udisks2.enable = true;
    security.polkit.enable = true;
    environment.systemPackages = [ pkgs.udiskie ];

    security.polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
        if (subject.isInGroup("wheel")) {
          if (action.id.startsWith("org.freedesktop.udisks2.")) {
            return polkit.Result.YES;
          }
        }
      });
    '';
  };
}

