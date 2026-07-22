{ self, inputs, ... }: {
  flake.nixosModules.gimp = { pkgs, ... }:
    let
      gmicGimp = pkgs.gmic-qt.override { variant = "gimp"; };
    in {
      environment.systemPackages = with pkgs; [
        gimp3
        gmicGimp
      ];

      system.activationScripts.gmicGimpLink = {
        text = ''
          mkdir -p /home/claudio/.config/GIMP/3.2/plug-ins
          ln -sfn ${gmicGimp}/lib/gimp/3.0/plug-ins/gmic_gimp_qt /home/claudio/.config/GIMP/3.2/plug-ins/gmic_gimp_qt
          chown -R claudio:users /home/claudio/.config/GIMP
        '';
      };
    };
}
