{ lib, config, pkgs, isDarwin, homeDir, ... }:

{
  direnv = {
    enable = true;
    nix-direnv = {
      enable = true;
    };
  };
  
  gpg = {
    enable = true;
    homedir = "${homeDir}/.gnupg";
    settings = {
      use-agent = true;
      default-key = "860B5C62BF1FCE4272D26BF8C3DE5DF6198DACBD";
    };
  };

  home-manager.enable = true;

  git = {
    enable = true;
    delta = {
      enable = true;
    };
    signing = {
      key = "C3DE5DF6198DACBD";
      signByDefault = true;
    };
    extraConfig.init.defaultBranch = "master";
    extraConfig.core.autocrlf = false;
    package = pkgs.gitAndTools.gitFull;
    userName = "willemml";
    userEmail = "willem@leit.so";
  };

  emacs.enable = true;

  zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  exa = {
    enable = true;
    enableAliases = true;
  };

  zsh = {
    enable = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    enableVteIntegration = true;
    autocd = true;
    defaultKeymap = "emacs";
    dirHashes = {
      docs = "$HOME/Documents";
      appsup = "$HOME/Library/Application Support";
      dls = "$HOME/Downloads";
      ubc = "$HOME/Documents/school/ubc";
    };
    dotDir = ".config/zsh";
    history = {
      path = "$HOME/.local/zsh/history";
      extended = true;
      ignoreDups = true;
    };
    plugins = with pkgs; [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = lib.cleanSource ./p10k-config;
        file = "p10k.zsh";
      }
    ];
  };
}
