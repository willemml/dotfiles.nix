{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.coreutils-full ];
  environment.variables.SHELL = "${pkgs.zsh}/bin/zsh";
  environment.variables.LANGUAGE = "en_US.UTF-8";
  environment.variables.LC_CTYPE = "en_US.UTF-8";
  environment.variables.LANG = "en_US.UTF-8";

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

  programs.zsh.promptInit = ''
    autoload -U promptinit && promptinit
    setopt PROMPTSUBST
    _prompt_nix() {
      [ -z "$IN_NIX_SHELL" ] || echo "%F{yellow}%B[''${name:+$name}]%b%f "
    }
    PS1='%F{red}%B%(?..%? )%b%f%# '
    RPS1='$(_prompt_nix)%F{green}%~%f'
    if [ -n "$IN_NIX_SANDBOX" ]; then
      PS1+='%F{red}[sandbox]%f '
    fi
  '';

  time.timeZone = "America/Vancouver";

  users.users.willem.shell = pkgs.zsh;
}
