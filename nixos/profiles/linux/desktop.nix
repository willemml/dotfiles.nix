{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    freecad
    qbittorrent
    vlc
  ];

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
    enable = true;
    layout = "us";
    libinput.mouse.naturalScrolling = true;
    libinput.touchpad.naturalScrolling = true;
    xkbVariant = "colemak";
  };

  sound.enable = true;
}
