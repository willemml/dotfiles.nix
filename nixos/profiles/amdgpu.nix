{pkgs, ...}: {
  boot.kernelModules = ["amdgpu"];
  services.xserver.videoDrivers = ["amdgpu"];

  hardware.opengl = {
    driSupport = true;
    enable = true;
    extraPackages = [pkgs.amdvlk];
  };
}
