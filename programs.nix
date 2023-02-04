{ lib, config, pkgs, ... }:

{
  programs = {
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
      nix-direnv = { enable = true; };
    };

    exa = {
      enable = true;
      enableAliases = true;
    };

    firefox = {
      enable = true;
      extensions = [
      ];
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
      package = pkgs.nixpkgs-unstable.starship;
      settings = {
        format =
          "$os[](fg:#979797 bg:#444444)$directory$git_branch$git_status[](fg:#444444)$fill[](fg:#444444)$cmd_duration$time$line_break$character";
          fill = {
            symbol = "·";
            style = "fg:#505050";
          };
          cmd_duration = {
            disabled = false;
            min_time = 1500;
            style = "fg:#979797 bg:#444444";
            format = "[ $duration  ]($style)";
          };
          os = {
            disabled = false;
            style = "fg:#eaeaea bg:#444444";
            format = "[ $symbol ]($style)";
            symbols.Macos = "";
          };
          directory = {
            disabled = false;
            style = "fg:#149dff bg:#444444";
            format = "[  $path ]($style)";
            truncation_length = 3;
            truncation_symbol = "";
          };
          git_branch = {
            disabled = false;
            symbol = "";
            style = "fg:#53d306 bg:#444444";
            format = "[[](fg:#979797 bg:#444444)  $symbol $branch ]($style)";
          };
          git_status = {
            disabled = false;
            style = "bg:#444444";
            format =
              "[[$staged](fg:#cca107 bg:#444444)[$modified](fg:#cca107 bg:#444444)[$untracked](fg:#149dff bg:#444444)[$conflicted](fg:#ed0505 bg:#444444)]($style)";
          };
          time = {
            disabled = false;
            style = "fg:#4d7573 bg:#444444";
            format = "[ $time  ]($style)";
            time_format = "%T";
          };
      };
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      enableSyntaxHighlighting = true;
      enableVteIntegration = true;
      autocd = true;
      defaultKeymap = "emacs";
      envExtra = ''
        #!/usr/bin/env zsh
        export GPG_TTY=$(tty)
        eval $(gpg-agent --daemon -q 2>/dev/null)

        function gsearch() {
        open -a Safari "https://google.com/search?q=$(echo $@ | sed -e 's/ /%20/g')"
        }

        function plistxml2nix() {
        tail -n +4 |
        sed -e "s/<dict>/{/g"         \
        -e "s/<\/dict>/\}\;/g"    \
        -e "s/<key>/\"/g"         \
        -e "s/<\/key>/\"=/g"      \
        -e "s/<real>//g"          \
        -e "s/<\/real>/;/g"       \
        -e "s/<integer>//g"       \
        -e "s/<\/integer>/;/g"    \
        -e "s/<string>/\"/g"      \
        -e "s/<\/string>/\"\;/g"  \
        -e "s/<array>/\[/g"       \
        -e "s/<\/array>/\];/g"     \
        -e "s/<true\/>/true;/g"   \
        -e "s/<false\/>/false;/g" \
        -e "$ d" |
        sed \-e "$ s/;//"
        }
      '';
      dotDir = ".config/zsh";
      history = {
        path = "$HOME/.local/zsh/history";
        extended = true;
        ignoreDups = true;
      };
      shellAliases = {
        cd = "z";
        e = "emacsclient -c -nw";
        em = "emacs -nw";
        ew = "emacsclient -c";
        hms = "home-manager switch";
        l = "ls -1";
        np = "nix-shell -p";
        org = "z ${config.home.sessionVariables.ORGDIR}";
        ubc = "z ${config.home.sessionVariables.UBCDIR}";
        emw = "emacs";
      };
    };

    home-manager.enable = true;
  };
}
