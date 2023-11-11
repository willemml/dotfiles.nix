{pkgs, ...}: {
  imports = [
    ../../common/system.nix
    ../modules/nix/link-inputs.nix
    ../modules/nix/use-flake-pkgs.nix
    ../modules/darwin/hosts.nix
  ];

  nix = {
    generateNixPathFromInputs = true;
    generateRegistryFromInputs = true;
    linkInputs = true;
    linux-builder.enable = true;
  };

  networking.hostName = "zeus";
  networking.computerName = "Zeus";

  environment.etc."nix/user-sandbox.sb".text = ''
    (version 1)
    (allow default)
    (deny file-write*
          (subpath "/nix"))
    (allow file-write*
           (subpath "/nix/var/nix/gcroots/per-user")
           (subpath "/nix/var/nix/profiles/per-user"))
    (allow process-exec
          (literal "/bin/ps")
          (with no-sandbox))
  '';

  environment.loginShell = "${pkgs.zsh}/bin/zsh -l";

  programs.zsh.loginShellInit = ''
    reexec() {
        unset __NIX_DARWIN_SET_ENVIRONMENT_DONE
        unset __ETC_ZPROFILE_SOURCED __ETC_ZSHENV_SOURCED __ETC_ZSHRC_SOURCED
        exec $SHELL -c 'echo >&2 "reexecuting shell: $SHELL" && exec $SHELL -l'
    }
    reexec-sandbox() {
        unset __NIX_DARWIN_SET_ENVIRONMENT_DONE
        unset __ETC_ZPROFILE_SOURCED __ETC_ZSHENV_SOURCED __ETC_ZSHRC_SOURCED
        export IN_NIX_SANDBOX=1
        exec /usr/bin/sandbox-exec -f /etc/nix/user-sandbox.sb $SHELL -l
    }
  '';

  services.nix-daemon.enable = true;

  users.users.willem = {
    home = "/Users/willem";
    isHidden = false;
    name = "willem";
  };
}
