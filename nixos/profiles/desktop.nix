{
  pkgs,
  globals,
  ...
}: {
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.printing.enable = true;

  hardware.pulseaudio.enable = false;

  security.rtkit.enable = true;

  services.xserver = {
    layout = globals.keyboard.layout;
    libinput.mouse.naturalScrolling = true;
    libinput.touchpad.naturalScrolling = true;
    xkbVariant = globals.keyboard.variant;
  };

  sound.enable = true;
}
