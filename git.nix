{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    delta = {
      enable = true;
    };
    signing = {
#      gpgPath = "${pkgs.gpg.outPath}";
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
