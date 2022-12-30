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
      package = pkgs.gnupg;
      homedir = "${config.home.homeDirectory}/.gnupg";
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
      envExtra = ''
        export PATH=${pkgs.pinentry_mac.out}/Applications/pinentry-mac.app/Contents/MacOS:$PATH
        export GPG_TTY=$(tty)

        eval $(gpg-agent --daemon -q 2>/dev/null)
      '';
      dotDir = ".config/zsh";
      history = {
        path = "$HOME/.local/zsh/history";
        extended = true;
        ignoreDups = true;
      };
      shellAliases = {
        emw = "emacs";
        em = "emacs -nw";
        ew = "emacsclient -c";
        e = "emacsclient -c -nw";
        np = "nix-shell -p";
        hms = "home-manager switch";
        cd = "z";
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
