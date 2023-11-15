{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ../profiles/hyprland.nix
    ../profiles/default.nix
    ../users/willem/home/linux.nix
    ../modules/zerotier.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.availableKernelModules = ["ehci_pci" "ahci" "uas" "sd_mod" "rtsx_pci_sdmmc"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/1fb0caa2-f036-4403-b75f-beed8ba54984";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/49F5-0E0A";
    fsType = "vfat";
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/aed88966-e44e-4d2f-99ba-1fe6fb57cf89";}
  ];

  networking.useDHCP = lib.mkDefault true;
  networking.hostName = "thinkpad";

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
