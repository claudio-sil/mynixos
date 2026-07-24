{ self, inputs, ... }: {
  flake.nixosModules.blenderCuda = { pkgs, ... }: {
    # pkgs.blender.override { cudaSupport = true; } hits a known, long-standing
    # nixpkgs bug: OpenImageDenoise's CUDA device build fails to locate nvcc
    # (CUDAToolkit_ROOT gets malformed). See NixOS/nixpkgs#303489 - unresolved
    # across multiple nixpkgs/OIDN versions.
    #
    # blender-bin sidesteps this entirely: it just downloads Blender's official
    # prebuilt binary from blender.org, which already ships working CUDA
    # support compiled upstream. No local build, no OIDN CUDA bug.
    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = [
      pkgs.blender-bin
    ];
  };
}
