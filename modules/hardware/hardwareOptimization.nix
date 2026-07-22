{ self, inputs, ... }: {
flake.nixosModules.hardwareOptimization = { pkgs, lib, config, ... }: {
# 1. zram: Compressed RAM for fast swapping
    zramSwap = {
      enable = true;
      memoryPercent = 50; # Uses up to 16GB of your 32GB
      priority = 100;     # High priority ensures zram is used before the disk
    };

    # 2. Swap File: Safety net on your SSD (/)
    swapDevices = [ {
      device = "/var/lib/swapfile";
      size = 16384; # 16GB (Total swap = 16GB zram + 16GB disk)
      priority = 10; # Low priority so it's only used as a last resort
    } ];

    # 3. SSD Workspace: Create a folder on the SSD for high-speed editing/LLMs
    # This prevents your HDD (/home) from bottlenecking the 3080 Ti
    systemd.tmpfiles.rules = [
      "d /ssd-work 0775 claudio wheel -"
    ];
    
  };
}
