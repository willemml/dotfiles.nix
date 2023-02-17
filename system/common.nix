{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.coreutils-full ];
  environment.variables.LANG = "en_US.UTF-8";
  environment.variables.LANGUAGE = "en_US.UTF-8";
  environment.variables.LC_ALL = "en_US.UTF-8";
  environment.variables.LC_CTYPE = "en_US.UTF-8";
  environment.variables.SHELL = "${pkgs.zsh}/bin/zsh";

  nix = {
    generateNixPathFromInputs = true;
    generateRegistryFromInputs = true;
    linkInputs = true;
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
    settings.trusted-users = [ "root" "willem" ];
  };

  
  programs.nix-index.enable = true;

  programs.zsh.enable = true;
  programs.zsh.enableBashCompletion = true;

  time.timeZone = "America/Vancouver";

  users.users.willem.shell = pkgs.zsh;
}
