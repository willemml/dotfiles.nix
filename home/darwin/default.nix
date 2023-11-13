{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ../modules/nix/use-flake-pkgs.nix
    ../modules/nix/pkgs-config.nix
    ../default.nix
    ./finder.nix
    ./iterm2.nix
    ./keybinds.nix
    ./launchd.nix
  ];

  home.homeDirectory = "/Users/willem";

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
    drs = "nix run nix-darwin -- switch --flake ${config.home.homeDirectory}/.config/dotfiles.nix#";
    dbs = "nix run nix-darwin -- build --flake ${config.home.homeDirectory}/.config/dotfiles.nix#";
    o = "open";
    oa = "open -a";
  };

  programs.zsh.envExtra =
    /*
    sh
    */
    ''
      export WINEPREFIX="${config.home.homeDirectory}/.gptk_wineprefix"

      if [ "$(arch)" = "arm64" ]; then
          eval "$(/opt/homebrew/bin/brew shellenv)"
          wine-gptk(){ arch -x86_64 /bin/zsh -c "WINEESYNC=1 \$(brew --prefix game-porting-toolkit)/bin/wine64 $@"; }
      else
          eval "$(/usr/local/bin/brew shellenv)"
          wine-gptk(){ WINEESYNC=1 $(brew --prefix game-porting-toolkit)/bin/wine64 "$@"; }
      fi

      gptk-steam(){ wine-gptk "${config.home.homeDirectory}/.gptk_wineprefix/drive_c/Program\ Files\ \(x86\)/Steam/steam.exe"; }
    '';

  programs.emacs.extraPackages = epkgs:
    with epkgs; [
      swift-mode
      company-sourcekit
    ];

  home.packages = with pkgs;
    [
      colima
      pngpaste
      spoof-mac
    ]
    ++ (let
      pkgs_x86_only = pkgs // {system = "x86_64-darwin";};
    in (with pkgs_x86_only; [
      gcc-arm-embedded
    ]));

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
