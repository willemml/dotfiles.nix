{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ../profiles/default.nix
    ../users/willem
    ../modules/zerotier.nix
  ];

  boot.loader.grub.enable = true;

  boot.initrd.availableKernelModules = ["ata_piix" "uhci_hcd" "sata_sil" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = [];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/4f558bc6-e3b3-46e4-a3b1-520eab6d090f";
    fsType = "ext4";
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/413077c1-e921-4377-8c7d-ca2acf8a60d2";}
  ];

  networking.useDHCP = lib.mkDefault true;

  networking.hostName = "p4box";

  nixpkgs.hostPlatform = lib.mkDefault "i686-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
