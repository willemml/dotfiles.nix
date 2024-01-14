{
  inputs,
  overlays,
  pkgs,
  globals,
  ...
}: {
  imports = [
    ../../common/system.nix
    ../modules/nix/use-flake-pkgs.nix
    ../modules/nix/optimise.nix
    ../modules/nix/cachix.nix
    ../modules/comma.nix
    ../users/willem/linux.nix
    inputs.stylix.nixosModules.stylix
  ];

  programs.command-not-found.enable = false;

  console.keyMap = "colemak";
  console.packages = [pkgs.terminus_font];

  environment.systemPackages = [pkgs.parted];

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

  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;

  system.stateVersion = "23.05";

  nixpkgs.overlays = builtins.attrValues overlays;
  nixpkgs.config.allowUnfree = true;
}
