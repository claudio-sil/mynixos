{ self, inputs, ... }: {

  flake.nixosModules.myMachineConfiguration = { pkgs, lib, ... }: {
    imports = [
      self.nixosModules.myMachineHardware
      self.nixosModules.niri
      self.nixosModules.nvidia
      self.nixosModules.gdm
      self.nixosModules.bluetooth
      self.nixosModules.blender
      self.nixosModules.davinci-resolve
      self.nixosModules.spotify
      self.nixosModules.discord
      self.nixosModules.udisks
      self.nixosModules.files
      self.nixosModules.surfshark
      self.nixosModules.helix
      self.nixosModules.gimp
      self.nixosModules.hardwareOptimization
    ];



  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

#  boot.kernelPackages = pkgs.linuxPackages_6_12;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "mictlan"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Tel_Aviv";

  # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.claudio = {
    isNormalUser = true;
    extraGroups = [ "wheel" "disk" "networkmanager" ]; # Enable ‘sudo’ for the user.
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
#    substituters = [ "https://cache.nixos-cuda.org" ];
    download-buffer-size = 524288000;
#    trusted-public-keys = [ "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M=" ];
  };

  environment.systemPackages = with pkgs; [
    firefox
    wget
    curl
    git
    vim
    alacritty
    btop
    bat
    ];
  

  system.stateVersion = "25.11";
};
}
