{
  lib,
  config,
  pkgs,
  ...
}: {
  launchd = lib.mkIf pkgs.stdenv.isDarwin {
    enable = true;

    agents.emacs = {
      enable = true;
      config = {
        ProgramArguments = [
          "${config.programs.emacs.finalPackage}/bin/emacs"
          "--fg-daemon"
        ];
        KeepAlive = true;
        UserName = "${config.home.username}";
        ProcessType = "Adaptive";
        StandardOutPath = "${config.home.homeDirectory}/Library/Logs/emacs-stdout.log";
        StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/emacs-stderr.log";
      };
    };

    agents.offlineimap = {
      enable = true;
      config = {
        ProgramArguments = ["${pkgs.offlineimap}/bin/offlineimap"];
        UserName = "${config.home.username}";
        StartInterval = 900;
        StandardOutPath = "${config.home.homeDirectory}/Library/Logs/offlineimap-stdout.log";
        StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/offlineimap-stderr.log";
      };
    };

    agents.rss2email = {
      enable = true;
      config = {
        ProgramArguments = [
          "${pkgs.rss2email}/bin/r2e"
          "run"
        ];
        UserName = "${config.home.username}";
        StartInterval = 3600;
        StandardOutPath = "${config.home.homeDirectory}/Library/Logs/rss2email-stdout.log";
        StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/rss2email-stderr.log";
      };
    };
  };
}
