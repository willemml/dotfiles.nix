{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hyprland.nix
    ./default.nix
    ../users/willem/home/linux.nix
    ../modules/zerotier.nix
  ];
  boot.kernelModules = ["vhci-hcd" "usbip-core" "usbip-vudc" "usbip-host"];
  environment.systemPackages = [pkgs.linuxPackages.usbip];
  powerManagement.cpuFreqGovernor = "performance";
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
