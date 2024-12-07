{
  pkgs,
  lib,
  globals,
  ...
}: {
  environment.pathsToLink = ["/share/zsh"];
  environment.shells = [pkgs.bashInteractive pkgs.zsh];
  environment.systemPackages = [pkgs.coreutils pkgs.git];

  environment.variables = let
    lang = globals.language;
  in {
    LANG = lang;
    LANGUAGE = lang;
    LC_ALL = lang;
    LC_CTYPE = lang;
    SHELL = "${pkgs.zsh}/bin/zsh";
  };

  networking.hostFiles = [
    ./hosts/ubc
    ./hosts/zerotier
  ];

  nix = {
    package = pkgs.nix;
    settings.experimental-features = ["nix-command" "flakes"];
    settings.trusted-users = ["root" "willem"];
  };

  programs.bash.interactiveShellInit = ''
    export PS1=$'\n'"\e[0mbash: \e[34;1m\w"$'\n'"\e[32m\\$\e[0m "
  '';

  documentation.enable = true;
  documentation.man.enable = true;

  programs.zsh.enable = true;
  programs.zsh.shellInit = lib.mkDefault "zsh-newuser-install() { :; }";
  programs.zsh.enableBashCompletion = true;
  programs.zsh.promptInit = lib.mkDefault ''
    autoload -U promptinit && promptinit
    export PROMPT="${globals.zsh.prompt}"
    export RPROMPT="${globals.zsh.rprompt}"
  '';

  time.timeZone = globals.timezone;

  users.users.willem.shell = pkgs.zsh;
}
