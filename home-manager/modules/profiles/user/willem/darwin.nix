{ config, pkgs, lib, inputs, ... }:

let
  inherit (lib) mkIf;
  inherit (pkgs) stdenv;
  appCommands = {
    calibre = "Calibre";
    ical = "Calendar";
    im = "Messages";
    maps = "Maps";
    music = "Music";
    safari = "Safari";
    settings = "System Settings";
    zotero = "Zotero";
  };
in
{
  imports = [ ./launchd.nix ./iterm2.nix ./finder.nix ];

  home.file.".gnupg/gpg-agent.conf" = mkIf stdenv.isDarwin {
    text = ''
      pinentry-program "${pkgs.pinentry-touchid}/bin/pinentry-touchid"
      default-cache-ttl 30
      max-cache-ttl 600
    '';
  };

  home.file.".config/zsh/am.sh" = mkIf stdenv.isDarwin {
    executable = true;
    source = builtins.fetchurl {
      url =
        "https://raw.githubusercontent.com/mcthomas/Apple-Music-CLI-Player/27353ec55abac8b5d73b8a061fb87f305c663adb/src/am.sh";
      sha256 = "sha256-78zRpNg7/OR7p8dpsJt6Xc4j0Y+8zSUtm/PT94nf03M=";
    };
  };

  programs.zsh.shellAliases = mkIf stdenv.isDarwin ({
    drs = "darwin-rebuild switch --flake ${config.home.homeDirectory}/.config/dotfiles.nix#";
    dbs = "darwin-rebuild build --flake ${config.home.homeDirectory}/.config/dotfiles.nix#";
    f = "open \"$(${config.programs.fzf.package}/bin/fzf)\"";
    o = "open";
    oa = "open -a";
    pinentry = "pinentry-mac";
  } // lib.attrsets.mapAttrs (name: value: "open -a '" + value + "'") appCommands);

  programs.firefox.package = mkIf stdenv.isDarwin (pkgs.callPackage ../overlays/firefox-mac.nix { inherit pkgs; });
  programs.chromium.package = mkIf stdenv.isDarwin (pkgs.callPackage ../overlays/chromium-mac.nix { inherit pkgs; });

  targets.darwin = mkIf stdenv.isDarwin {
    defaults = {
      NSGlobalDomain = {
        AppleLanguages = [ "en-CA" ];
        AppleLocale = "en_CA";
      };
      "com.apple.Safari" = {
        AutoOpenSafeDownloads = false;
        IncludeDevelopMenu = true;
        ShowFullURLInSmartSearchField = true;
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
