{
  inputs,
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ../profiles/hyprland.nix
    ../users/willem/home/linux.nix
    ../modules/zerotier.nix
    inputs.nixos-apple-silicon.nixosModules.apple-silicon-support
  ];

  boot.initrd.availableKernelModules = ["usb_storage" "sdhci_pci"];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/62169b05-efa5-482c-9664-6683b6d474ce";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/3CAD-1DF4";
    fsType = "vfat";
  };

  swapDevices = [];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  hardware.asahi.peripheralFirmwareDirectory = ./firmware;
  
  hardware.asahi = {
    withRust = true;
    addEdgeKernelConfig = true;
    useExperimentalGPUDriver = true;
    experimentalGPUInstallMode = "overlay";
  };

  systemd.services.limit-charge = {
    enable = true;
    description = "Limit battery charge to 80%.";
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      User = "root";
      Group = "root";
    };
    script = ''
      ${pkgs.coreutils}/bin/echo 80 > /sys/class/power_supply/macsmc-battery/charge_control_end_threshold
    '';
  };

  hardware.opengl.enable = true;
  networking.wireless.iwd = {
    enable = true;
    settings.General.EnableNetworkConfiguration = true;
  };

  networking.hostName = "voyager";
}
