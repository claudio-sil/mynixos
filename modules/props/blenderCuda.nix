{ self, inputs, ... }: {
  flake.nixosModules.blenderCuda = { pkgs, ... }: {
    # pkgs.blender.override { cudaSupport = true; } hits a known, long-standing
    # nixpkgs bug: OpenImageDenoise's CUDA device build fails to locate nvcc
    # (CUDAToolkit_ROOT gets malformed). See NixOS/nixpkgs#303489 - unresolved
    # across multiple nixpkgs/OIDN versions.
    #
    # blender-bin isn't part of nixpkgs itself - it's a separate flake
    # (github:edolstra/nix-warez?dir=blender) that just fetches Blender's
    # official prebuilt binary from blender.org, CUDA already working.
    # Added as a flake input in flake.nix; referenced here via `inputs`,
    # which is already in scope from this file's own `{ self, inputs, ... }`.
    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = [
      inputs.blender-bin.packages.${pkgs.system}.default
    ];
  };
}
