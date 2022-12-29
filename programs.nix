{ lib, config, pkgs, ... }:

{
  programs = {
    home-manager.enable = true;
    
    direnv = {
      enable = true;
      nix-direnv = { enable = true; };
    };

    gpg = {
      enable = true;
      settings = {
        use-agent = true;
        default-key = "860B5C62BF1FCE4272D26BF8C3DE5DF6198DACBD";
      };
    };

    java = {
      enable = true;
      package = pkgs.jdk;
    };

    git = {
      enable = true;
      delta = { enable = true; };
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
      envExtra =
        "export PATH=${pkgs.pinentry_mac.out}/Applications/pinentry-mac.app/Contents/MacOS:$PATH";
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
      shellAliases = {
        em = "emacsclient -c";
        emt = "emacsclient -c -nw";
        np = "nix-shell -p";
        hms = "home-manager switch";
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
  };
}
