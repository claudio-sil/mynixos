{ self, inputs, ... }: {
  flake.nixosModules.surfshark = { pkgs, ... }: {
    networking.networkmanager.enable = true;
    networking.networkmanager.plugins = with pkgs; [
      networkmanager-openvpn
    ];

    environment.systemPackages = with pkgs; [
      wireguard-tools
      networkmanager-openvpn
    ];
  };
}
