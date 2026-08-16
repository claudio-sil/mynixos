{ self, inputs, ... }: {
  perSystem = { pkgs, ... }: {
    packages.myNoctaliaMictlan = inputs.wrapper-modules.wrappers.noctalia-shell.wrap {
      inherit pkgs;
      settings =
        (builtins.fromJSON
          (builtins.readFile ./noctalia-mictlan.json)).settings;
    };

    packages.myNoctaliaDuat = inputs.wrapper-modules.wrappers.noctalia-shell.wrap {
      inherit pkgs;
      settings =
        (builtins.fromJSON
          (builtins.readFile ./noctalia-duat.json)).settings;
    };
  };
}
