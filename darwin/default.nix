{ config, pkgs, lib, inputs, ... }:

{
  imports = [ ./launchd.nix ./apps.nix ];

  targets.darwin = {
    defaults = {
      "com.googlecode.iterm2" = import ./iterm2.nix;
      "com.apple.finder" = import ./finder.nix;
      NSGlobalDomain = {
        AppleLanguages = [ "en-CA" ];
        AppleLocale = "en_CA";
        AppleMeasurementUnits = "Centimeters";
        AppleMetricUnits = true;
        AppleTemperatureUnit = "Celsius";
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
      };
      "com.apple.Safari" = {
        AutoOpenSafeDownloads = false;
        IncludeDevelopMenu = true;
        ShowFullURLInSmartSearchField = true;
      };
      "com.apple.dock" = {
        autohide = true;
        launchanim = false;
        magnification = false;
        minimize-to-application = true;
        mru-spaces = false;
        orientation = "bottom";
        static-only = true;
        tilesize = 35;
        workspaces-swoosh-animation-off = true;
      };
      "com.apple.menuextra.clock" = {
        DateFormat = "EEE d MMM HH:mm:ss";
        FlashDateSeparators = false;
      };
      "com.apple.controlcenter" = {
        "NSStatusItem Visible AccessibilityShortcuts" = false;
        "NSStatusItem Visible AirDrop" = false;
        "NSStatusItem Visible Battery" = true;
        "NSStatusItem Visible Bluetooth" = true;
        "NSStatusItem Visible Clock" = true;
        "NSStatusItem Visible Display" = false;
        "NSStatusItem Visible FocusModes" = false;
        "NSStatusItem Visible NowPlaying" = true;
        "NSStatusItem Visible ScreenMirroring" = true;
        "NSStatusItem Visible Sound" = true;
        "NSStatusItem Visible StageManager" = false;
        "NSStatusItem Visible UserSwitcher" = false;
        "NSStatusItem Visible WiFi" = true;
      };
      "com.apple.systempreferences" = {
        "com.apple.preference.battery".hasBeenWarnedAboutEnergyUsage = true;
      };
      com.apple.appleseed.FeedbackAssistant.Autogather = false;
      com.apple.TextEdit.RichText = false;
    };
    currentHostDefaults = {
      "com.apple.controlcenter".BatteryShowPercentage = true;
      "com.apple.dock".DidPromptSearchEngineAlert = true;
    };
  };
}
