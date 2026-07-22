# ─────────────────────────────────────────────────────────────────────────────
# hardware.nix — Fill in your actual values after running:
#   nixos-generate-config --show-hardware-config
# Then replace this file (or import the generated hardware-configuration.nix).
# ─────────────────────────────────────────────────────────────────────────────
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # ── Boot ──────────────────────────────────────────────────────────────────
  boot.initrd.availableKernelModules = [
    "xhci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc"
  ];
  boot.initrd.kernelModules = [];
  boot.kernelModules        = [ "kvm-intel" ];
  boot.extraModulePackages  = [];

  # ── Filesystem — EDIT THESE UUIDs (from lsblk -f or blkid) ───────────────
  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXOS";   # ← change to your UUID/label
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/BOOT";    # ← change to your UUID/label
    fsType = "vfat";
    options = [ "fmask=0022" "dmask=0022" ];
  };

  swapDevices = [ { device = "/dev/disk/by-label/SWAP";} ];                        # ← add swap partition if needed

  # ── CPU ───────────────────────────────────────────────────────────────────
  hardware.cpu.intel.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;

  # ── NVIDIA GeForce 920M — legacy (Maxwell) ────────────────────────────────
  # 920M is a Maxwell-era card; the correct legacy driver is 470.xx.
  # We use the proprietary driver (open = false) as requested.
  hardware.nvidia = {
    modesetting.enable   = true;
    open                 = false;          # proprietary, not open-source kernel module
    nvidiaSettings       = true;
    package              = config.boot.kernelPackages.nvidiaPackages.legacy_470;

    # 920M is an Optimus (hybrid Intel + NVIDIA) laptop GPU.
    # PRIME offload lets you run apps on the dGPU on demand.
    prime = {
      offload = {
        enable            = true;
        enableOffloadCmd  = true;          # provides `nvidia-offload` wrapper
      };
      # ⚠ Set these to YOUR actual PCI bus IDs (lspci | grep -E 'VGA|3D')
      intelBusId  = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  hardware.graphics = {
    enable          = true;
    enable32Bit = true;
    #driSupport      = false;
    #driSupport32Bit = false;
  };
}
