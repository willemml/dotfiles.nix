{pkgs, ...}: {
  imports = [
    ./hyprland.nix
    ./default.nix
    ../users/willem/home/linux.nix
    ../modules/zerotier.nix
  ];
  powerManagement.cpuFreqGovernor = "performance";
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
