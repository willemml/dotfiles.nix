{pkgs, ...}: {
  imports = [./common.nix];

  console.keyMap = "colemak";

  i18n.defaultLocale = "en_US.UTF-8";

  programs.command-not-found.enable = false;

  programs.zsh.loginShellInit = ''
    reexec() {
        unset __NIX_OS_SET_ENVIRONMENT_DONE
        unset __ETC_ZPROFILE_SOURCED __ETC_ZSHENV_SOURCED __ETC_ZSHRC_SOURCED
        exec $SHELL -c 'echo >&2 "reexecuting shell: $SHELL" && exec $SHELL -l'
    }
  '';

  services.udev.enable = true;

  system.stateVersion = "22.11";

  users.users.willem = {
    isNormalUser = true;
    extraGroups = ["networkmanager" "wheel"];
  };
}
