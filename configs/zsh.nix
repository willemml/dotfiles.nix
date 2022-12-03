{ pkgs, ... }:

{
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.zsh = {
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
  
