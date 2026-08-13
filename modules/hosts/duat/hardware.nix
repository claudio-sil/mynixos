{ self, inputs, ... }: {

  flake.nixosModules.duatHardware = { config, lib, pkgs, modulesPath, ... }: {
    imports = [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

    # ── Architecture (Required for NixOS System Evaluation) ──────────────
    nixpkgs.hostPlatform = "x86_64-linux";

    # ── Boot & Drivers ───────────────────────────────────────────────────
    boot.initrd.availableKernelModules = [
      "xhci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc"
    ];
    boot.initrd.kernelModules = [];
    boot.kernelModules        = [ "kvm-intel" ];
    boot.extraModulePackages  = [];

    # ── Wireless & Power Tweaks (ath9k Fixes) ────────────────────────────
    # 1. Disable ath9k hardware power-saving & force software crypto (fixes packet loss)
    boot.extraModprobeConfig = ''
      options ath9k ps_enable=0 nohwcrypt=1
    '';

    # 2. Disable PCIe link power management (ASPM) to prevent slot drops
    boot.kernelParams = [ "pcie_aspm=off" ];

    # 3. Disable NetworkManager power saving globally
    networking.networkmanager.wifi.powersave = false;

    # 4. Reload ath9k module automatically when waking from suspend
    systemd.services.reload-ath9k-on-resume = {
      description = "Reload ath9k driver after system resume";
      wantedBy = [ "post-resume.target" ];
      after = [ "post-resume.target" ];
      script = ''
        /run/current-system/sw/bin/modprobe -r ath9k || true
        /run/current-system/sw/bin/modprobe ath9k
      '';
    };

    # ── Filesystem ───────────────────────────────────────────────────────
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

    # ── NVIDIA GeForce 920M ───────────────────────────────────────────────
    services.xserver.videoDrivers = [ "nvidia" ];
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
