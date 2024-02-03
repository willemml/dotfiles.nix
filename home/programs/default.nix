{
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./ssh.nix
    ./zsh.nix
  ];

  programs = {
    helix = {
      enable = true;
      settings.editor.line-number = "relative";
      settings.keys = {
        normal = {
          space.w = ":w";
          space.q = ":q";

          /*
          remap for colemak
          */
          n = "move_line_down";
          N = "keep_selections";
          k = "search_next";
          K = "search_prev";
          # E <=> J (swap actions)
          j = "move_next_word_end";
          J = "move_next_long_word_end";
          e = "move_line_up";
          E = "join_selections";
          # ILU loop
          # I => L
          i = "move_char_right";
          I = "no_op";
          # U => I (QWERTY position)
          u = "insert_mode";
          U = "insert_at_line_start";
          # L => U (QWERTY position)
          l = "undo";
          L = "redo";
          /*
          end colemak remap
          */
        };
      };
    };

    nix-index-database.comma.enable = true;

    bash.enableCompletion = true;

    alacritty = {
      enable = true;
      settings = {
        font.normal.style = lib.mkForce "Book";
        window = {
          decorations = "None";
        };
      };
    };

    direnv = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      nix-direnv = {enable = true;};
    };

    eza = {
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
      delta = {enable = true;};
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
      package = pkgs.gitFull;
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

    password-store = {
      enable = true;
      package = pkgs.pass.withExtensions (exts: [exts.pass-genphrase exts.pass-otp exts.pass-import]);
      settings = {
        PASSWORD_STORE_DIR = "${config.home.homeDirectory}/.password-store";
        PASSWORD_STORE_CLIP_TIME = "60";
        PASSWORD_STORE_KEY = "48BD20833B6AE9AA";
      };
    };

    zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };

    home-manager.enable = true;
  };
}
