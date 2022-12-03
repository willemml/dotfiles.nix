{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    delta = {
      enable = true;
    };
    signing = {
      gpgPath = "/opt/homebrew/bin/gpg";
      key = "C3DE5DF6198DACBD";
      signByDefault = true;
    };
    extraConfig.init.defaultBranch = "master";
    extraConfig.core.autocrlf = false;
    package = pkgs.gitAndTools.gitFull;
    userName = "willemml";
    userEmail = "willem@leit.so";
  };
}
