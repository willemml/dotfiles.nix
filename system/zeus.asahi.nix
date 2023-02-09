{ pkgs, ... }:

{
  imports = [ ./nixos.common.nix ./nixos.gnome.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  networking.hostName = "zeus-asahi";
}
