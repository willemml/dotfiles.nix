{pkgs, ...}: {
  imports = [
    ./hyprland.nix
    ./default.nix
    ../users/willem/home/linux.nix
    ../modules/zerotier.nix
  ];
  environment.systemPackages = [pkgs.powertop];
  services.logind = {
    extraConfig = ''
      HandlePowerKey=suspend
      HandleLidSwitchDocked=suspend
    '';
    lidSwitch = "suspend";
  };
  powerManagement.powertop.enable = true;
  networking.wireless.iwd = {
    enable = true;
    settings.General.EnableNetworkConfiguration = true;
  };
}
