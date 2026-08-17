{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # Add a specific pointer for your bleeding-edge packages
    nixpkgs-blender.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    wrapper-modules.url = "github:BirdeeHub/nix-wrapper-modules";
    sops-nix.url = "git+https://github.com/Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake
    { inherit inputs; }
    {
      imports = [ (inputs.import-tree ./modules) ];

      perSystem = { system, ... }: {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            android_sdk.accept_license = true;
          };
          overlays = [
            (final: prev: {
              # Pull blender explicitly from your second input if needed, 
              # or use an overlay to map it cleanly.
              blender = (import inputs.nixpkgs-blender {
                inherit system;
                config.allowUnfree = true;
              }).blender;
            })
          ];
        };
      };
    };
}
