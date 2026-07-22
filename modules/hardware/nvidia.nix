{ self, inputs, ... }: {
  flake.nixosModules.nvidia = { pkgs, lib, config, ... }: {
#    nixpkgs.config.allowUnfree = true;


    hardware.graphics.enable = true;
    hardware.graphics.enable32Bit = true;
    hardware.graphics.extraPackages = with pkgs; [
      nvidia-vaapi-driver
      vulkan-loader
      vulkan-validation-layers
      cudaPackages.cuda_cudart # Cuda runtime support
    ];

    environment.systemPackages = with pkgs; [
      vulkan-tools
    ];

    hardware.nvidia = {
        modesetting.enable = true;
        # Stick to 'false' for the most stable CUDA/OptiX experience in 2026
        open = false; 
        package = config.boot.kernelPackages.nvidia_x11_production;
      };

    hardware.nvidia.powerManagement.enable = true;

    services.xserver.videoDrivers = [ "nvidia" ];

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      WLR_NO_HARDWARE_CURSORS = "1";
    };
  };
}
