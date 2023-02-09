{ pkgs, ... }:

{
  imports = [ ./common.nix ];
  
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
  environment.systemPackages = with pkgs; [
    colima
    darwin-zsh-completions
    discord
    freecad-mac
    gnused
    iterm2
    pinentry-touchid
    pinentry-mac
    pngpaste
    qbittorrent-mac
    spoof-mac
    spotify-mac
    utm
    vlc-mac
  ];

  launchd.user.agents.iterm2 = {
    command = "${pkgs.iterm2}/Applications/iTerm2.app/Contents/MacOS/iTerm2";
    serviceConfig = {
      KeepAlive = true;
      ProcessType = "Adaptive";
    };
  };

  programs.bash.enable = true;

  programs.man.enable = true;

  programs.zsh.enableFzfCompletion = true;
  programs.zsh.enableFzfGit = true;
  programs.zsh.enableFzfHistory = true;
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

  system = {
    defaults = {
      loginwindow = {
        SHOWFULLNAME = false;
        GuestEnabled = false;
        DisableConsoleAccess = true;
      };
      LaunchServices.LSQuarantine = false;
      dock = {
        autohide = true;
        launchanim = false;
        minimize-to-application = true;
        mru-spaces = false;
        orientation = "bottom";
        static-only = true;
        tilesize = 35;
      };
      NSGlobalDomain = {
        "com.apple.sound.beep.feedback" = 1;
        AppleICUForce24HourTime = true;
        AppleInterfaceStyle = "Dark";
        AppleMeasurementUnits = "Centimeters";
        AppleMetricUnits = 1;
        AppleShowAllExtensions = true;
        AppleShowScrollBars = "WhenScrolling";
        AppleTemperatureUnit = "Celsius";
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        NSAutomaticWindowAnimationsEnabled = false;
        NSDocumentSaveNewDocumentsToCloud = false;
        NSNavPanelExpandedStateForSaveMode = true;
        NSNavPanelExpandedStateForSaveMode2 = true;
        NSTableViewDefaultSizeMode = 1;
        NSTextShowsControlCharacters = true;
        NSWindowResizeTime = 0.0;
      };
      trackpad = {
        FirstClickThreshold = 0;
        SecondClickThreshold = 2;
        Clicking = true;
      };
    };

    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
      # see https://developer.apple.com/library/content/technotes/tn2450/_index.html for more info
      userKeyMapping = [{
        HIDKeyboardModifierMappingSrc = 30064771303; # remap right command to right control.
        HIDKeyboardModifierMappingDst = 30064771300;
      }];
    };
  };

  users.users.willem = {
    home = "/Users/willem";
    isHidden = false;
    name = "willem";
  };
}
