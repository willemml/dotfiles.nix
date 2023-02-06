{ lib, config, pkgs, ... }:

{
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
        StandardErrorPath =
          "${config.home.homeDirectory}/Library/Logs/emacs-stderr.log";

      };
    };

    agents.spotifyd = {
      enable = true;
      config = {
        ProgramArguments = [
          "${pkgs.spotifyd}/bin/spotifyd"
          "--no-daemon"
          "--username-cmd"
          "${pkgs.pass}/bin/pass 'music/spotify' | grep login | cut -f2 -d ' '"
          "--password-cmd"
          "${pkgs.pass}/bin/pass 'music/spotify' | head -n1"
          "--backend"
          "portaudio"
        ];
        KeepAlive = true;
        UserName = "${config.home.username}";
        StandardOutPath = "${config.home.homeDirectory}/Library/Logs/spotifyd-stdout.log";
        StandardErrorPath =
          "${config.home.homeDirectory}/Library/Logs/spotifyd-stderr.log";

      };
    };
  };
}
