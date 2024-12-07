{
  config,
  pkgs,
  ...
}: {
  hardware.graphics.enable = true;

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.beta;
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    # use closed source drivers
    open = false;
    nvidiaSettings = true;
  };

  services.xserver.videoDrivers = ["nvidia"];
}
