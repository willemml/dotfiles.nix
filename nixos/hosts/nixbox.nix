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
    ../modules/users/willem/home.nix
    ../modules/zerotier.nix
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["amdgpu"];
  boot.extraModulePackages = [];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.opengl.driSupport = true;

  hardware.opengl.extraPackages = with pkgs; [
    amdvlk
  ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/9b616ca8-63fe-4d81-a13e-25c9a95a1a55";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/4FEE-904E";
    fsType = "vfat";
  };

  swapDevices = [];

  networking.useDHCP = lib.mkDefault true;

  networking.hostName = "nixbox";

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
