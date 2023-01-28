{ lib, config, pkgs, ... }:

{
  launchd = lib.mkIf pkgs.stdenv.isDarwin {
    enable = true;

    agents.emacs = {
      enable = true;
      config = {
        ProgramArguments = [ "${config.home.homeDirectory}/.nix-profile/bin/emacs" "--fg-daemon" ];
        KeepAlive = true;
        UserName = "${config.home.username}";
        ProcessType = "Adaptive";
        StandardOutPath = "${config.home.homeDirectory}/.emacs.d/daemon-stdout";
        StandardErrorPath =
          "${config.home.homeDirectory}/.emacs.d/daemon-stderr";
      };
    };
  };
}
