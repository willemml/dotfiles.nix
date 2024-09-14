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
    ../users/willem/home/darwin.nix
    ../modules/yabai
    inputs.nix-index-database.darwinModules.nix-index
  ];

  programs.nix-index-database.comma.enable = true;

  homebrew = {
    enable = true;
    brews = [
      "R"
      "qmk/qmk/qmk"
      "arm-none-eabi-gcc@8"
      "avr-gcc@8"
    ];
    taps = ["qmk/qmk" "osx-cross/arm" "osx-cross/avr"];
    casks = [
      "UTM"
      "arduino-ide"
      "blackhole-16ch"
      "blobsaver"
      "discord"
      "homebrew/cask-versions/firefox-esr"
      "rstudio"
      "obs"
      "jellyfin-media-player"
      "steam"
      "thunderbird"
      "vial"
      "whisky"
      "zerotier-one"
    ];
  };

  environment.systemPath = [
    "/opt/homebrew/opt/arm-none-eabi-binutils/bin"
    "/opt/homebrew/opt/arm-none-eabi-gcc@8/bin"
    "/opt/homebrew/opt/avr-gcc@8/bin"
  ];

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
