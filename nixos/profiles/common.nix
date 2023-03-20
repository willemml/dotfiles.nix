{pkgs, ...}: {
  environment.pathsToLink = ["/share/zsh"];
  environment.shells = [pkgs.bashInteractive pkgs.zsh];
  environment.systemPackages = [pkgs.coreutils-full];
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
    settings.experimental-features = ["nix-command" "flakes" "repl-flake"];
    settings.trusted-users = ["root" "willem"];
  };

  programs.nix-index.enable = false;

  programs.bash.enableCompletion = true;
  programs.bash.interactiveShellInit = ''
    export PS1=$'\n'"\e[0mbash: \e[34;1m\w"$'\n'"\e[32m\\$\e[0m "
  '';

  documentation.man.enable = true;

  programs.zsh.enable = true;
  programs.zsh.enableBashCompletion = true;
  programs.zsh.promptInit = ''
    autoload -U promptinit && promptinit
    export PROMPT=$'\n'"%B%F{blue}%3~"$'\n'"%F{green}%(!.#.$) %f%b"
    export RPROMPT="%B%F{red}%*%f%b"
  '';

  time.timeZone = "America/Vancouver";

  users.users.willem.shell = pkgs.zsh;
}
