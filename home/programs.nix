{ lib, config, inputs, pkgs, ... }:

{
  programs = {
    bash.enableCompletion = true;

    browserpass = {
      enable = true;
      browsers = [
        "chromium"
        "firefox"
      ];
    };

    chromium = {
      enable = true;
      extensions = [
        { id = "naepdomgkenhinolocfifgehidddafch"; } # browserpass
        { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
      ];
    };

    direnv = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      nix-direnv = { enable = true; };
    };

    exa = {
      enable = true;
      enableAliases = true;
    };

    firefox = {
      enable = true;
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        browserpass
        bypass-paywalls-clean
        clearurls
        don-t-fuck-with-paste
        dracula-dark-colorscheme
        edit-with-emacs
        fastforward
        i-dont-care-about-cookies
        multi-account-containers
        musescore-downloader
        offline-qr-code-generator
        ublock-origin
        zoom-redirector
      ];
    };

    fzf = {
      enable = true;
      defaultCommand = "${pkgs.fd}/bin/fd . ${config.home.homeDirectory}";
      enableZshIntegration = true;
    };

    git = {
      enable = true;
      delta = { enable = true; };
      signing = {
        key = "C3DE5DF6198DACBD";
        signByDefault = true;
      };
      extraConfig = {
        init.defaultBranch = "master";
        core.autocrlf = false;
        push.autoSetupRemote = true;
      };
      lfs.enable = true;
      package = pkgs.gitAndTools.gitFull;
      userName = "willemml";
      userEmail = "willem@leit.so";
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

    starship = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      package = pkgs.starship;
    };

    zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };

    zsh = {
      enable = true;

      autocd = true;
      defaultKeymap = "emacs";
      dotDir = ".config/zsh";
      enableAutosuggestions = true;
      enableCompletion = true;
      enableSyntaxHighlighting = true;
      enableVteIntegration = true;

      history = {
        path = "$HOME/.local/zsh/history";
        extended = true;
        ignoreDups = true;
      };

      historySubstringSearch.enable = true;

      loginExtra = ''
        # -*-sh-*-
        export GPG_TTY=$(tty)
        eval $(gpg-agent --daemon -q 2>/dev/null)
        function gsearch() {
            open -a Safari "https://google.com/search?q=$(echo $@ | sed -e 's/ /%20/g')"
        }
        nixify() {
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
          ];
        }
        EOF
            ${config.home.sessionVariables.EDITOR} default.nix
          fi
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

      shellAliases = {
        cd = "z";
        e = "emacsclient -c -nw";
        em = "emacs -nw";
        emw = "emacs";
        ew = "emacsclient -c";
        l = "ls -1";
        np = "nix-shell -p";
        nrs = lib.mkIf pkgs.stdenv.isLinux "sudo nixos-rebuild switch --flake ${config.home.homeDirectory}/.config/dotfiles.nix#";
        nbs = lib.mkIf pkgs.stdenv.isLinux "sudo nixos-rebuild build --flake ${config.home.homeDirectory}/.config/dotfiles.nix#";
        org = "z ${config.home.sessionVariables.ORGDIR}";
        ubc = "z ${config.home.sessionVariables.UBCDIR}";
      };
    };

    home-manager.enable = true;
  };
}
