{ pkgs, ... }:

{
  imports = [ ./common.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  console.keyMap = "colemak";

  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
  ]) ++ (with pkgs.gnome; [
    cheese # webcam tool
    gnome-music
    gedit # text editor
    epiphany # web browser
    geary # email reader
    evince # document viewer
    gnome-characters
    totem # video player
    tali # poker game
    iagno # go game
    hitori # sudoku game
    atomix # puzzle game
  ]);

  environment.systemPackages = with pkgs; [
    freecad
    pinentry-gnome
    qbittorrent
    vlc
  ];

  i18n.defaultLocale = "en_US.UTF-8";

  programs.command-not-found.enable = false;

  programs.zsh.loginShellInit = ''
    reexec() {
        unset __NIX_OS_SET_ENVIRONMENT_DONE
        unset __ETC_ZPROFILE_SOURCED __ETC_ZSHENV_SOURCED __ETC_ZSHRC_SOURCED
        exec $SHELL -c 'echo >&2 "reexecuting shell: $SHELL" && exec $SHELL -l'
    }
  '';

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
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    layout = "us";
    libinput.mouse.naturalScrolling = true;
    libinput.touchpad.naturalScrolling = true;
    xkbVariant = "colemak";
  };

  sound.enable = true;

  system.stateVersion = "22.11";

  users.users.willem = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
  };
}
