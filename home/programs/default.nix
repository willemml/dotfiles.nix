{
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./emacs
    ./kitty
    ./ssh.nix
    ./zsh.nix
  ];

  programs = {
    bash.enableCompletion = true;

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

    hishtory = {
      enable = true;
      enableZshIntegration = true;
    };

    java = {
      enable = true;
      package = pkgs.jdk;
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
