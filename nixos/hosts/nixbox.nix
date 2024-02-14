{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../profiles/desktop.nix
    ../profiles/amdgpu.nix
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.extraModulePackages = [];

  boot.kernelParams = ["intel_iommu=on"];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostId = "06818aaa";

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/fe61bc5b-3b71-4819-8083-522f2c283252";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/9624-F744";
    fsType = "vfat";
  };

  swapDevices = [];

  environment.systemPackages = [pkgs.zfs];

  services.zfs.autoScrub.enable = true;

  networking.hostName = "nixbox";

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
