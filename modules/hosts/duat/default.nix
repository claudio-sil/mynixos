{ self, inputs, ... }: {

  flake.nixosConfigurations.duat = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      { nixpkgs.config.allowUnfree = true; }
      self.nixosModules.duatConfiguration
    ];
  };

}
