{
  pkgs,
  inputs,
  config,
  ...
}: {
  imports = [
    ../../common/system.nix
    ../modules/nix/link-inputs.nix
    ../modules/nix/optimise.nix
    ../modules/nix/use-flake-pkgs.nix
    ../modules/nix/cachix.nix
    ../modules/comma.nix
    ../users/willem/home/darwin.nix
    ../modules/yabai
    inputs.stylix.darwinModules.stylix
  ];

  # build of normal noto emoji fonts fails on darwin
  stylix.fonts.emoji.package = pkgs.noto-fonts-emoji-blob-bin;

  system.activationScripts.extraActivation.text = ''
    osascript -e 'tell application "System Events" to tell every desktop to set picture to "${config.stylix.image}"'
  '';

  homebrew = {
    enable = true;
    casks = [
      "blackhole-16ch"
      "zerotier-one"
      "discord"
      "nordvpn"
      "obs"
      "steam"
      "vial"
      "whisky"
      "homebrew/cask-versions/firefox-esr"
      "UTM"
    ];
  };

  services.karabiner-elements.enable = true;

  nix = {
    generateNixPathFromInputs = true;
    generateRegistryFromInputs = true;
    linkInputs = true;
    linux-builder.enable = true;
  };

  networking.hostName = "zeus";
  networking.computerName = "Zeus";

  nix.gc.interval.Hour = 5;

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
}
