{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ../default.nix
    ./finder.nix
    ./keybinds.nix
    ./launchd.nix
  ];

  programs.ssh.includes = ["/Users/willem/.colima/ssh_config"];

  home.file.".gnupg/gpg-agent.conf" = {
    text = ''
      pinentry-program "${pkgs.pinentry.out}/bin/pinentry"
      allow-emacs-pinentry
      default-cache-ttl 30
      max-cache-ttl 600
    '';
  };

  programs.zsh.shellAliases = {
    drs = "darwin-rebuild switch --flake ${config.home.homeDirectory}/.config/dotfiles.nix#";
    dbs = "darwin-rebuild build --flake ${config.home.homeDirectory}/.config/dotfiles.nix#";
    o = "open";
    oa = "open -a";
  };

  programs.zsh.envExtra =
    /*
    sh
    */
    ''
      if [ "$(arch)" = "arm64" ]; then
          eval "$(/opt/homebrew/bin/brew shellenv)"
      else
          eval "$(/usr/local/bin/brew shellenv)"
      fi
    '';

  home.packages = [pkgs.colima];

  targets.darwin = {
    defaults = {
      NSGlobalDomain = {
        AppleLanguages = ["en-CA"];
        AppleLocale = "en_CA";
        "com.apple.sound.beep.feedback" = 1;
        AppleICUForce24HourTime = true;
        AppleInterfaceStyle = "Dark";
        AppleMeasurementUnits = "Centimeters";
        AppleMetricUnits = true;
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
      com.apple.Safari = {
        AutoOpenSafeDownloads = false;
        IncludeDevelopMenu = true;
        ShowFullURLInSmartSearchField = true;
      };
      com.apple.menuextra.clock = {
        DateFormat = "EEE d MMM HH:mm:ss";
        FlashDateSeparators = false;
      };
      com.apple.controlcenter = {
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
      com.apple.systempreferences = {
        "com.apple.preference.battery".hasBeenWarnedAboutEnergyUsage = true;
      };
      com.apple.appleseed.FeedbackAssistant.Autogather = false;
      com.apple.TextEdit.RichText = false;
      loginwindow = {
        SHOWFULLNAME = false;
        GuestEnabled = false;
        DisableConsoleAccess = true;
      };
      LaunchServices.LSQuarantine = false;
      com.apple.dock = {
        autohide = true;
        launchanim = false;
        minimize-to-application = true;
        mru-spaces = false;
        orientation = "bottom";
        static-only = true;
        tilesize = 35;
      };
      com.apple.driver.AppleBluetoothMultitouch.trackpad = {
        FirstClickThreshold = 0;
        SecondClickThreshold = 2;
        Clicking = true;
      };
    };
    currentHostDefaults = {
      "com.apple.controlcenter".BatteryShowPercentage = true;
      "com.apple.dock".DidPromptSearchEngineAlert = true;
    };
  };
}
