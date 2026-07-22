{ self, inputs, ... }: {
  flake.nixosModules.discord = { pkgs, ... }: {
    nixpkgs.config.allowUnfree = true;
    environment.systemPackages = [ pkgs.discord ];
  };
}
