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
    syntaxHighlighting = {
      enable = true;
    };
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


        function s() {
            ${shellAliases.web} "https://google.com/search?q=$(echo $@ | sed -e 's/ /%20/g')"
        }

        nixifypy() {
          if [ ! -e ./.envrc ]; then
            echo "use nix" > .envrc
            direnv allow
          fi
          if [[ ! -e shell.nix ]] && [[ ! -e default.nix ]]; then
            cat > default.nix <<'EOF'
        with import <nixpkgs> {};
        mkShell {
          nativeBuildInputs = [
            bashInteractive
            (pkgs.python310.withPackages (p: with p; [  ]))
          ];
        }
        EOF
            ${config.home.sessionVariables.EDITOR} default.nix
          fi
        }

        flakify() {
          if [ ! -e flake.nix ]; then
            nix flake new -t github:nix-community/nix-direnv .
          elif [ ! -e .envrc ]; then
            echo "use flake" > .envrc
            direnv allow
          fi
          ${config.home.sessionVariables.EDITOR} flake.nix
        }
      '';

    localVariables = {
      PROMPT = "\n%B%F{blue}%~\n%F{green}$ %f%b";
      RPROMPT = "%B%F{red}%*%f%b";
    };

    shellAliases = rec {
      cd = "z";
      discord = "${web} https://discord.com/channels/@me";
      dotd = "cd ${config.home.sessionVariables.DOTDIR} ";
      e = "emacsclient -c -nw";
      em = "emacs -nw";
      email = "${ew} -n --eval '(mu4e)'";
      emw = "emacs";
      ew = "emacsclient -c -n";
      getmail = "${pkgs.offlineimap}/bin/offlineimap -f INBOX";
      l = "ls -1";
      np = "nix-shell -p";
      org = "cd ${config.home.sessionVariables.ORGDIR} ";
      spotify = "${web} https://open.spotify.com/";
      ubc = "cd ${config.home.sessionVariables.UBCDIR} ";
      ubcmail = "${web} https://webmail.student.ubc.ca";
      web = "${config.programs.firefox.package}/bin/firefox";
      hmr = "nix run home-manager -- build --flake ${config.home.sessionVariables.DOTDIR}#";
      hms = "nix run home-manager -- switch --flake ${config.home.sessionVariables.DOTDIR}#";
    };
  };
}
