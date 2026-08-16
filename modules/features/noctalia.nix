{ self, inputs, ... }: {
  perSystem = { pkgs, ... }: {
    packages.myNoctaliaMictlan = inputs.wrapper-modules.wrappers.noctalia-shell.wrap {
      inherit pkgs;
      settings =
        (builtins.fromJSON
          (builtins.readFile ./noctalia-mictlan.json)).settings;
      # Seeds this into $HOME/.config/noctalia on first run only; after
      # that noctalia reads/writes there directly, so live changes made
      # in the app's own settings UI actually persist across restarts.
      outOfStoreConfig = "$HOME/.config/noctalia";
    };

    packages.myNoctaliaDuat = inputs.wrapper-modules.wrappers.noctalia-shell.wrap {
      inherit pkgs;
      settings =
        (builtins.fromJSON
          (builtins.readFile ./noctalia-duat.json)).settings;
      outOfStoreConfig = "$HOME/.config/noctalia";
    };
  };
}
