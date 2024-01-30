{
  config,
  pkgs,
  ...
}: {
  programs.zsh = rec {
    enable = true;

    autocd = true;
    defaultKeymap = "emacs";
    dotDir = ".config/zsh";
    enableAutosuggestions = true;
    enableCompletion = true;
    # syntaxHighlighting = {
    #   enable = true;
    # };
    enableVteIntegration = true;

    initExtraBeforeCompInit = ''
      fpath+=(${config.home.profileDirectory}/share/zsh/site-functions)
    '';

    history = {
      path = "$HOME/.local/zsh/history";
      extended = true;
      ignoreDups = true;
    };

    historySubstringSearch.enable = true;

    loginExtra =
      /*
      sh
      */
      ''
        export GPG_TTY=$(tty)

        if [ -n "$INSIDE_EMACS" ]; then
            chpwd() {
                print -P "\032/$(pwd)"
            }
        fi

        flakify() {
          if [ ! -e flake.nix ]; then
            nix flake new -t github:nix-community/nix-direnv .
          elif [ ! -e .envrc ]; then
            echo "use flake" > .envrc
            direnv allow
          fi
          '${config.home.sessionVariables.EDITOR}' flake.nix
        }
      '';

    localVariables = {
      PROMPT = "\n%B%F{cyan}%m:%F{blue}%~\n%F{green}$ %f%b";
      RPROMPT = "%B%F{red}%*%f%b";
    };

    shellAliases = rec {
      s = "kitten ssh";
      ke = "kitten edit-in-kitty";
      cd = "z";
      dotd = "cd ${config.home.sessionVariables.DOTDIR} ";
      l = "ls -1";
      lh = "ls --hyperlink";
      np = "nix-shell -p";
      hmr = "nix run home-manager -- build --flake ${config.home.sessionVariables.DOTDIR}#";
      hms = "nix run home-manager -- switch --flake ${config.home.sessionVariables.DOTDIR}#";
    };
  };
}
