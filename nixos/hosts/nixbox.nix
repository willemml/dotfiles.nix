{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../profiles/desktop.nix
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["amdgpu"];
  boot.extraModulePackages = [];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.supportedFilesystems = ["zfs"];
  boot.zfs.forceImportRoot = false;
  networking.hostId = "06818aaa";

  hardware.opengl.driSupport = true;
  hardware.opengl.enable = true;

  hardware.opengl.extraPackages = with pkgs; [
    amdvlk
  ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/24855432-019b-43d9-9b83-9135b9dc31a6";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/F2E9-F515";
    fsType = "vfat";
  };

  boot.zfs.extraPools = ["zpool"];

  swapDevices = [{device = "/dev/disk/by-uuid/36bb51f0-f56d-4408-b61c-7905789a7304";}];

  environment.systemPackages = [pkgs.zfs];

  services.zfs.autoScrub.enable = true;

  services.jellyfin.enable = true;

  users.groups.torrent.gid = torrent_group_id;

  networking.hostName = "nixbox";

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
