# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  ...
}: {
  boot.initrd.kernelModules = ["vfio_pci" "vfio" "vfio_iommu_type1" "vfio_virqfd"];

  imports = [
    ../profiles/desktop.nix
    ../profiles/nvidiagpu.nix
  ];

  boot.initrd.availableKernelModules = ["vmd" "xhci_pci" "nvme" "ahci" "usbhid" "usb_storage" "sd_mod"];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];

  boot.kernelParams = let vfio-pci-devs = ["10de:2482" "10de:228b"]; in ["intel_iommu=on" ("vfio-pci.ids=" + lib.concatStringsSep "," vfio-pci-devs)];

  virtualisation.spiceUSBRedirection.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/18ed28ca-03c5-4ed8-8a31-fac727b74722";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/DFEC-14F2";
    fsType = "vfat";
  };

  swapDevices = [];

  networking.hostName = "glassbox";

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
