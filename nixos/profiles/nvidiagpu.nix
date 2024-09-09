{...}: {
  hardware.graphics.enable = true;

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    # use closed source drivers
    open = false;
    nvidiaSettings = true;
  };
}
