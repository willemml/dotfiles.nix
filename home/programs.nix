{ lib, config, inputs, pkgs, ... }: {
  imports = [ ./emacs.nix ./firefox.nix ];

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

    fzf = {
      enable = true;
      defaultCommand = "${pkgs.ripgrep}/bin/rg --files --hidden --no-ignore-vcs";
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

    mu.enable = true;

    offlineimap = {
      enable = true;
      pythonFile = ''
        import subprocess
        def get_pass(service, cmd):
            return subprocess.check_output(cmd, ).splitlines()[0]
      '';
    };

    zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };

    zsh = rec {
      enable = true;

      autocd = true;
      defaultKeymap = "emacs";
      dotDir = ".config/zsh";
      enableAutosuggestions = true;
      enableCompletion = true;
      enableSyntaxHighlighting = true;
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

      loginExtra = ''
        # -*-sh-*-
        export GPG_TTY=$(tty)
        eval $(gpg-agent --daemon -q 2>/dev/null)
        function s() {
            ${shellAliases.web} "https://google.com/search?q=$(echo $@ | sed -e 's/ /%20/g')"
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
        ew = "emacsclient -c";
        l = "ls -1";
        np = "nix-shell -p";
        org = "cd ${config.home.sessionVariables.ORGDIR} ";
        spotify = "${web} https://open.spotify.com/";
        ubc = "cd ${config.home.sessionVariables.UBCDIR} ";
        ubcmail = "${web} https://webmail.student.ubc.ca";
        web = "${pkgs.coreutils-full}/bin/nohup ${config.programs.firefox.package}/bin/firefox &> ${config.home.homeDirectory}/.firefox.log";
      } // (if pkgs.stdenv.isLinux then {
        nbs = "sudo nixos-rebuild build --flake ${config.home.sessionVariables.DOTDIR}#";
        nrs = "sudo nixos-rebuild switch --flake ${config.home.sessionVariables.DOTDIR}#";
      } else { });
    };

    home-manager.enable = true;
  };
}
