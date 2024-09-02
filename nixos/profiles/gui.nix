{
  pkgs,
  globals,
  ...
}: {
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6001", MODE="0666"
  '';
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.dbus = {
    enable = true;
    packages = [pkgs.dconf];
  };

  programs.dconf = {
    enable = true;
  };

  services.printing.enable = true;

  hardware.pulseaudio.enable = false;

  security.rtkit.enable = true;

  services.xserver = {
    enable = true;

    xkb.layout = globals.keyboard.layout;
    xkb.variant = globals.keyboard.variant;

    synaptics.enable = false;

    displayManager.lightdm.enable = false;
  };

  services.libinput = {
    enable = true;
    touchpad.tapping = true;
    touchpad.naturalScrolling = true;
    touchpad.scrollMethod = "twofinger";
    touchpad.disableWhileTyping = true;
    touchpad.clickMethod = "clickfinger";
  };
}
