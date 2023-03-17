{
  home.file = {
    ".config/nix/nix.conf".text = ''
      allow-dirty = true
      experimental-features = flakes nix-command repl-flake
      builders-use-substitutes = true
    '';
    ".config/nixpkgs/config.nix".text = ''
      # -*-nix-*-
      {
        nixpkgs.config.allowUnfreePredicate = (_: true);
        allowUnfree = true;
      }

    '';
  };
}
