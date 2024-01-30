{
  lib,
  config,
  pkgs,
  ...
}: let
  logFile = name: "${config.home.homeDirectory}/Library/Logs/${name}.log";
in {
  launchd = {
    enable = true;
  };
}
