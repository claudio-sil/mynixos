{ self, inputs, ... }: {
  flake.nixosModules.blenderCuda = { pkgs, ... }: {
    # pkgs.blender.override { cudaSupport = true; } hits a known, long-standing
    # nixpkgs bug: OpenImageDenoise's own CUDA *device* build fails to locate
    # nvcc (CUDAToolkit_ROOT gets malformed). See NixOS/nixpkgs#303489 -
    # confirmed still present on blender-5.2.0 / openimagedenoise-2.4.1.
    #
    # Workaround attempt: Blender's own CUDA rendering (Cycles kernels, what
    # the RTX 3080 Ti actually uses) is a *separate* thing from OIDN's
    # optional CUDA denoising backend. Try disabling cudaSupport on just the
    # openimagedenoise dependency while keeping it on for blender itself.
    # UNVERIFIED - blender's default.nix may not expose openimagedenoise as
    # an overridable arg in this exact shape; if this errors with something
    # like "anonymous function does not accept an argument named
    # 'openimagedenoise'", the override hook doesn't exist and this path is
    # a dead end - fall back to blender-bin instead.
    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = [
      (pkgs.blender.override {
        cudaSupport = true;
        openimagedenoise = pkgs.openimagedenoise.override {
          cudaSupport = false;
        };
      })
    ];
  };
}
