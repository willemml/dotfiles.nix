{
  config,
  pkgs,
  ...
}: {
  programs.firefox = {
    enable = true;
    package = pkgs.stdenv.mkDerivation {
      name = "firefox-with-policies";
      src =
        if pkgs.stdenv.isDarwin
        then pkgs.firefox-mac
        else pkgs.firefox;
      policiesJson =
        /*
        json
        */
        ''
          {
              "policies": {
                  "DisableAppUpdate": true,
                  "DisableFirefoxAccounts": true,
                  "DisableFirefoxStudies": true,
                  "DisableTelemetry": true,
                  "DisablePocket": true,
                  "DontCheckDefaultBrowser": true,
                  "PasswordManagerEnabled": false
              }
          }
        '';
      buildPhase =
        /*
        sh
        */
        ''
          #
          mkdir -p $out/bin
          cp -r $src/Applications $out/Applications
          export RESOURCESDIR="$out/Applications/Firefox.app/Contents/Resources"
          chmod +w $RESOURCESDIR
          mkdir $RESOURCESDIR/distribution
          echo $policiesJson > $RESOURCESDIR/distribution/policies.json
          chmod -w $RESOURCESDIR

          cat <<EOF>>$out/bin/firefox
          #! ${pkgs.bash}/bin/bash -e
          exec "$out/Applications/Firefox.app/Contents/MacOS/Firefox"  "\$@"
          EOF

          chmod +x $out/bin/firefox
        '';
    };
    profiles.primary = {
      id = 0;
      isDefault = true;
      search = {
        force = true;
        default = "Google";
        order = [
          "Google"
          "DuckDuckGo"
        ];
        engines = {
          "Nix Packages" = {
            urls = [
              {
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "type";
                    value = "packages";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];

            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = ["@np"];
          };

          "NixOS Wiki" = {
            urls = [{template = "https://nixos.wiki/index.php?search={searchTerms}";}];
            iconUpdateURL = "https://nixos.wiki/favicon.png";
            updateInterval = 24 * 60 * 60 * 1000; # every day
            definedAliases = ["@nw"];
          };

          "Bing".metaData.hidden = true;
        };
      };
      settings = {
        "app.update.auto" = false;
        "app.update.checkInstallTime" = false;
        "app.update.silent" = true;
        "browser.aboutConfig.showWarning" = false;
        "browser.bookmarks.showMobileBookmarks" = true;
        "browser.download.alwaysOpenPanel" = false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
        "browser.newtabpage.activity-stream.feeds.topsites" = false;
        "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = false;
        "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
        "browser.newtabpage.activity-stream.section.highlights.includeVisited" = false;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.newtabpage.enabled" = false;
        "browser.search.isUS" = false;
        "browser.search.region" = "CA";
        "browser.startup.homepage" = "";
        "browser.warnOnQuitShortcut" = false;
        "distribution.searchplugins.defaultLocale" = "en-CA";
        "extensions.recommendations.hideNotice" = true;
        "general.autoScroll" = false;
        "general.useragent.locale" = "en-CA";
        "layout.spellcheckDefault" = false;
        "media.autoplay.default" = 5;
        "permissions.default.camera" = 2;
        "permissions.default.desktop-notifications" = 2;
        "permissions.default.microphone" = 2;
        "print_printer" = "Mozilla Save to PDF";
        "privacy.donottrackheader.enabled" = true;
        "signon.rememberSignons" = false;
      };
      extensions = with pkgs.rycee-firefox-addons; [
        browserpass
        #bypass-paywalls-clean
        clearurls
        don-t-fuck-with-paste
        #dracula-dark-colorscheme
        #edit-with-emacs
        #fastforward
        i-dont-care-about-cookies
        musescore-downloader
        offline-qr-code-generator
        ublock-origin
        zoom-redirector
      ];
      bookmarks = [
        {
          name = "wikipedia";
          keyword = "wiki";
          url = "https://en.wikipedia.org/wiki/Special:Search?search=%s&go=Go";
        }
        {
          name = "kernel.org";
          url = "https://www.kernel.org";
        }
        {
          name = "Nix sites";
          bookmarks = [
            {
              name = "homepage";
              url = "https://nixos.org/";
            }
            {
              name = "wiki";
              keyword = "nixwiki";
              url = "https://nixos.wiki/";
            }
          ];
        }
      ];
    };
  };
}
