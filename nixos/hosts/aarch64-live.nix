{inputs, ...}: {
  imports = [
    ../profiles/live-image.nix
    ../modules/apple-silicon.nix
  ];

  isoImage.makeEfiBootable = true;

  hardware.asahi.extractPeripheralFirmware = false;

  networking.wireless.enable = false;

  networking.wireless.iwd = {
    enable = true;
    settings.General.EnableNetworkConfiguration = true;
  };

  networking.hostName = "nixos-live-aarch64";
}
