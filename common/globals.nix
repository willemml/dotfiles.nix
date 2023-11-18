{
  keyboard.layout = "us";
  keyboard.variant = "colemak";

  language = "en_US.UTF-8";

  sshkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBx1z962nl87rmOk/vw3EBSgqU/VlCqON8zTeLHQcSBp willem@zeus";

  zsh.prompt = "\n%B%F{cyan}%m:%F{blue}%~\n%F{green}$ %f%";
  zsh.rprompt = "%B%F{red}%*%f%b";

  timezone = "America/Vancouver";

  username = "willem";

  wallpapers = import ./wallpapers.nix;

  sshAuthorizedKeyFiles = [./sshpubkeys/willem-nixbox ./sshpubkeys/willem-thinkpad ./sshpubkeys/willem-zeus];
}
