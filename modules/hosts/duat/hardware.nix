{ self, inputs, ... }: {

  flake.nixosModules.duatHardware = { config, lib, pkgs, modulesPath, ... }: {
    imports = [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

    # ── Boot ──────────────────────────────────────────────────────────────
    boot.initrd.availableKernelModules = [
      "xhci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc"
    ];
    boot.initrd.kernelModules = [];
    boot.kernelModules        = [ "kvm-intel" ];
    boot.extraModulePackages  = [];

    # ── Filesystem — EDIT THESE to match `lsblk -f` / `blkid` on duat ─────
    fileSystems."/" = {
      device = "/dev/disk/by-label/NIXOS";
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

    swapDevices = [ { device = "/dev/disk/by-label/SWAP"; } ];

    # ── CPU ───────────────────────────────────────────────────────────────
    hardware.cpu.intel.updateMicrocode =
      lib.mkDefault config.hardware.enableRedistributableFirmware;

    # ── NVIDIA GeForce 920M — legacy (Maxwell) ────────────────────────────
    # Kept local to duat rather than using self.nixosModules.nvidia, since
    # that shared module targets a different driver/setup (no PRIME offload).
    hardware.nvidia = {
      modesetting.enable = true;
      open               = false;
      nvidiaSettings     = true;
      package            = config.boot.kernelPackages.nvidiaPackages.legacy_470;

      prime = {
        offload = {
          enable           = true;
          enableOffloadCmd = true;
        };
        # ⚠ Set these to duat's actual PCI bus IDs (lspci | grep -E 'VGA|3D')
        intelBusId  = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };

    hardware.graphics = {
      enable      = true;
      enable32Bit = true;
    };
  };

}
