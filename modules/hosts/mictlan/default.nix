{ self, inputs, ... }: {

  flake.nixosConfigurations.mictlan = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      { nixpkgs.config.allowUnfree = true; }
      self.nixosModules.myMachineConfiguration
    ];
  };

}
