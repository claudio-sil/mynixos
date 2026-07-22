# nixos/configuration.nix — Main system config (just imports)
{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware.nix
    ./modules/nix.nix
    ./modules/boot.nix
    ./modules/networking.nix
    ./modules/locale.nix
    ./modules/desktop.nix
    ./modules/graphics.nix
    ./modules/audio.nix
    ./modules/bluetooth.nix
    ./modules/users.nix
    ./modules/fonts.nix
    ./packages.nix
  ];

  # State version - never change after install
  system.stateVersion = "25.11";
}
