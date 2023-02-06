{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ ];

  nix.package = pkgs.nix;

  programs.bash.enable = true;

  programs.zsh.enable = true;

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
}
