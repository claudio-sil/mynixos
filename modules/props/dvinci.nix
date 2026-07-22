{ self, inputs, ... }: {
  flake.nixosModules.davinci-resolve = { pkgs, ... }: {
    
    # DaVinci Resolve is unfree software
    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = with pkgs; [
      davinci-resolve
    ];

    # DaVinci Resolve requires specific environment tweaks to find 
    # the OpenCL/CUDA drivers on Wayland/Niri
    environment.sessionVariables = {
      # Helps with UI scaling on high-res monitors if needed
      QT_DEVICE_PIXEL_RATIO = "auto";
      # Forces DaVinci to look for the correct OpenCL/CUDA backend
      OCL_ICD_VENDORS = "/run/opengl-driver/etc/OpenCL/vendors/nvidia.icd";
    };
  };
}
