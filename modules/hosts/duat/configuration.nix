{ self, inputs, ... }: {

  flake.nixosModules.duatConfiguration = { pkgs, lib, ... }: {
    imports = [
      self.nixosModules.duatHardware
      self.nixosModules.niri
      self.nixosModules.gdm
      self.nixosModules.bluetooth
      self.nixosModules.spotify
      self.nixosModules.discord
      self.nixosModules.udisks
      self.nixosModules.files
      self.nixosModules.surfshark
      self.nixosModules.helix
      self.nixosModules.gimp
      self.nixosModules.hardwareOptimization
      # note: self.nixosModules.nvidia intentionally NOT imported here —
      # duat's nvidia config lives in duatHardware instead
    ];

    nixpkgs.config = {
      allowUnfree = true;
      nvidia.acceptLicense = true;
    };

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    boot.kernelPackages = pkgs.linuxPackages_latest;

    networking.hostName = "duat";

    networking.networkmanager.enable = true;

    time.timeZone = "Asia/Tel_Aviv";

    users.users.claudio = {
      isNormalUser = true;
      extraGroups = [ "wheel" "disk" "networkmanager" ];
      packages = with pkgs; [
        tree
      ];
    };

    services.xserver.xkb = {
      layout = "us,il";
      options = "grp:win_space_toggle";
    };

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    nix.settings = {
      download-buffer-size = 524288000;
    };

    services.openssh = {
      enable = true;
      openFirewall = true;
    };

    environment.systemPackages = with pkgs; [
      eza
      openssh
      firefox
      wget
      curl
      git
      vim
      alacritty
      btop
      bat

      #Hardware diagnosis
      pciutils
      usbutils
      lshw
      dmidecode
      smartmontools
      nvme-cli
      lm_sensors

      #network diagnosis
      ethtool
      iperf3
      dnsutils
      traceroute
    ];

    system.stateVersion = "25.11";
  };

}
