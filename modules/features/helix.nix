{ self, inputs, ... }: {
  flake.nixosModules.helix = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.helix ];
  };
}
