{ config, pkgs, lib, inputs, ... }:

{
  imports = [ ./launchd.nix ./apps.nix ];

  targets.darwin = {
    defaults = {
      "com.googlecode.iterm2" = import ./iterm2.nix;
      "com.apple.finder" = import ./finder.nix;
      NSGlobalDomain = {
        AppleMeasurementUnits = "Centimeters";
        AppleLocale = "en_CA";
        AppleLanguages = [ "en-CA" ];
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
      };
    };
    currentHostDefaults."com.apple.controlcenter".BatteryShowPercentage = true;
  };
}
