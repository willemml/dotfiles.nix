{
  inputs,
  overlays,
  pkgs,
  ...
}: {
  imports = [
    ../../common/system.nix
    ../modules/nix/use-flake-pkgs.nix
    ../users/willem/default.nix
  ];

  console.keyMap = "colemak";
  console.packages = [pkgs.terminus_font];

  i18n.defaultLocale = "en_US.UTF-8";

  programs.zsh.loginShellInit = ''
    reexec() {
        unset __NIX_OS_SET_ENVIRONMENT_DONE
        unset __ETC_ZPROFILE_SOURCED __ETC_ZSHENV_SOURCED __ETC_ZSHRC_SOURCED
        exec $SHELL -c 'echo >&2 "reexecuting shell: $SHELL" && exec $SHELL -l'
    }
  '';

  programs.command-not-found.enable = false;

  services.udev.enable = true;

  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;

  system.stateVersion = "23.05";

  nixpkgs.overlays = builtins.attrValues overlays;
  nixpkgs.config.allowUnfree = true;
}
