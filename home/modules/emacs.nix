{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib.types) path str anything either package listOf;
  inherit (lib) mkIf mkEnableOption mkOption;
  cfg = config.programs.emacs;
  configFileOption = mkOption {
    type = either path str;
    default = "";
  };
  fileFromPathOrText = input:
    if (builtins.typeOf input) == "path"
    then {
      source = input;
    }
    else {
      text = input;
    };
in {
  options.programs.emacs = {
    enableOrgTex = mkEnableOption "Enable Emacs Org and LaTeX configuration";
    texPackages = mkOption {
      type = listOf package;
      default = [];
    };
    texEmacsPackages = lib.mkOption {
      type = anything;
      default = epkgs: [];
    };
    orgTexConfigFile = configFileOption;
    initFile = configFileOption;
    earlyInitFile = configFileOption;
  };

  config = {
    home.packages = mkIf cfg.enableOrgTex cfg.texPackages;

    programs.emacs.extraPackages = mkIf cfg.enableOrgTex cfg.texEmacsPackages;

    home.file.".emacs.d/nix-extraconfig.el".text = cfg.extraConfig;
    home.file.".emacs.d/org-tex-cfg.el" = mkIf cfg.enableOrgTex (fileFromPathOrText cfg.orgTexConfigFile);
    home.file.".emacs.d/early-init.el" = fileFromPathOrText cfg.earlyInitFile;
    home.file.".emacs.d/init.el" = fileFromPathOrText cfg.initFile;
  };
}
