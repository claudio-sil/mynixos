{ self, inputs, ... }: {
  flake.nixosModules.blender = { pkgs, ... }: {
    # This allows unfree packages specifically for this module's context
    nixpkgs.config.allowUnfree = true; 

    environment.systemPackages = [
      (pkgs.blender.override {
        cudaSupport = true;
      })
    ];
  };
}
