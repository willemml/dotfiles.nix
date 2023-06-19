{
  config,
  inputs,
  lib,
  modulesPath,
  pkgs,
  ...
}: {
  imports = [../profiles/linux/gnome.nix];

  boot.initrd.availableKernelModules = ["usb_storage" "sdhci_pci"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = [];
  boot.extraModulePackages = [];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/47408b5a-efcf-47b7-abd6-591b890fb1f3";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/315C-14F5";
    fsType = "vfat";
  };

  hardware.asahi.extractPeripheralFirmware = false;

  swapDevices = [];

  networking.useDHCP = lib.mkDefault true;
  networking.hostName = "zeusasahi";

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";
}
