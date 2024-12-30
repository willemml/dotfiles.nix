{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../../profiles/laptop.nix
    inputs.nixos-apple-silicon.nixosModules.apple-silicon-support
  ];
  environment.sessionVariables.MOZ_GMP_PATH = ["${pkgs.widevine}/gmp-widevinecdm/system-installed"];

  boot.initrd.availableKernelModules = ["usb_storage" "sdhci_pci"];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/62169b05-efa5-482c-9664-6683b6d474ce";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/3CAD-1DF4";
    fsType = "vfat";
  };

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  hardware.asahi.peripheralFirmwareDirectory = ./firmware;

  hardware.asahi = {
    withRust = true;
    useExperimentalGPUDriver = true;
    experimentalGPUInstallMode = "replace";
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

  hardware.graphics.enable = true;

  networking.hostName = "voyager";
}
