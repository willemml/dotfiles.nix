{ pkgs, ... }:

{
  imports = [ ../profiles/linux-common.nix ../profiles/gnome.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  networking.hostName = "zeus-asahi";
}
