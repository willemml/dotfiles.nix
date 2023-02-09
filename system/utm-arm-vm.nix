{ pkgs, ... }:

{
  imports = [ ./nixos.nix ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "virtio_pci" "usbhid" "usb_storage" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/10c8feb5-8fbb-490a-b144-dff00e82f3e9";
    fsType = "ext4";
  };

  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/3D0E-803C";
    fsType = "vfat";
  };

  services.spice-vdagentd.enable = true;

  swapDevices = [ ];
}
