{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkPackageOption;
  cfg = config.programs.hishtory;
  shellConfPath = "${cfg.package.outPath}/share/hishtory";
in {
  config.home.packages = mkIf cfg.enable [cfg.package];

  config.programs.bash.bashrcExtra = mkIf cfg.enableBashIntegration "source '${shellConfPath}/config.bash'";
  config.programs.fish.loginShellInit = mkIf cfg.enableFishIntegration "source '${shellConfPath}/config.fish'";
  config.programs.zsh.initExtra = mkIf cfg.enableZshIntegration "source '${shellConfPath}/config.zsh'";

  options.programs.hishtory = {
    enable = mkEnableOption "hishtory";

    enableZshIntegration = mkEnableOption "hishtory's Zsh integration";
    enableFishIntegration = mkEnableOption "hishtory's Fish integration";
    enableBashIntegration = mkEnableOption "hishtory's Bash integration";

    package = mkPackageOption pkgs "hishtory" {};
  };
}
