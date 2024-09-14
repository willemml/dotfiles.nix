{
  inputs,
  overlays,
  pkgs,
  globals,
  lib,
  ...
}: {
  imports = [
    ../../common/system.nix
    ../../common/stylix.nix
    ../modules/nix/use-flake-pkgs.nix
    ../modules/nix/optimise.nix
    ../modules/nix/cachix.nix
    ../modules/comma.nix
    ../users/willem/linux.nix
    inputs.stylix.nixosModules.stylix
  ];

  hardware.enableRedistributableFirmware = lib.mkDefault true;

  stylix = {
    fonts = rec {
      serif = sansSerif;

      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };

      monospace = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans Mono";
      };

      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };
  };

  networking = {
    useDHCP = lib.mkDefault true;

    nameservers = ["1.1.1.1" "1.0.0.1" "9.9.9.9" "2620:fe::fe" "2620:fe::9" "149.112.112.112"];

    dhcpcd.extraConfig = "nohook resolv.conf";
    networkmanager.dns = "none";
  };

  services.resolved.enable = false;

  programs.command-not-found.enable = false;

  boot.tmp.useTmpfs = lib.mkDefault true;

  boot.kernelParams = ["consoleblank=60"];

  console.keyMap = "colemak";
  console.packages = [pkgs.terminus_font];

  environment.systemPackages = with pkgs; [parted usbutils pciutils];

  services.zerotierone = {
    joinNetworks = globals.zerotier.networks;
    enable = true;
  };

  nix.gc.dates = "daily";

  i18n.defaultLocale = "en_US.UTF-8";

  programs.zsh.loginShellInit = ''
    reexec() {
        unset __NIX_OS_SET_ENVIRONMENT_DONE
        unset __ETC_ZPROFILE_SOURCED __ETC_ZSHENV_SOURCED __ETC_ZSHRC_SOURCED
        exec $SHELL -c 'echo >&2 "reexecuting shell: $SHELL" && exec $SHELL -l'
    }
  '';

  services.udev.enable = true;
  services.udev.extraRules = ''
    # USB-Blaster
    SUBSYSTEM=="usb", ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6001", MODE="0666"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6002", MODE="0666"

    SUBSYSTEM=="usb", ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6003", MODE="0666"

    # USB-Blaster II
    SUBSYSTEM=="usb", ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6010", MODE="0666"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6810", MODE="0666"
  '';

  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;

  system.stateVersion = "23.05";

  nixpkgs.overlays = builtins.attrValues overlays;
  nixpkgs.config.allowUnfree = true;
}
